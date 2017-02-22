
module RedditApi
  class Comments

    DEFAULT_MAX_MISSES = 2

    attr_reader :misses

    def initialize(args = {})
      @client = args.fetch(:client, RedditApi::Client.new)
      @comment_factory = RedditApi::Comment
      @query_factory =  RedditApi::Query
      @offset = nil
      @max_misses = args.fetch(:max_miss, DEFAULT_MAX_MISSES)
      @misses = args.fetch(:misses, 0)
      @last_count = 0
    end

    def most_recent_subreddits(user, count)
      subreddits = {}
      while subreddits.length < count && misses < max_misses
        comments = most_recent_comments(user, 100, offset)
        collect_subreddits(comments, count, subreddits)
        update_progress(comments, subreddits.length)
      end
      reset_collection_metrics
      subreddits.keys
    end

    def most_recent_comments(user, count, offset = nil)
      comments_data = most_recent_comment_data(user.username, count, offset)
      build_all_comments(comments_data)
    end

    protected
    attr_writer :offset, :misses
    attr_accessor  :last_count
    private
    attr_reader :client, :comment_factory, :offset, :query_factory,
                :max_misses

    def most_recent_comment_data(username, count, offset)
      return [] if username == "[deleted]"
      query = build_query(username, count, offset)
      client.get(query)
      query.captured_records
    end

    def build_query(username, count, offset)
      endpoint = "user/#{username}/comments.json"
      query_factory.new(count: count,
                        endpoint: endpoint,
                        resource: :comment,
                        offset: offset)
    end

    def update_progress(comments, new_count)
      if comments.empty? || last_count >= new_count
        self.misses += 1
      else
        self.offset = comments.last.reddit_id
        self.last_count += new_count
      end
    end

    def reset_collection_metrics
      self.misses = 0
      self.offset = nil
    end

    def build_all_comments(comments_data)
      comments_data.map! do |comment_data|
        build_comment(comment_data)
      end
    end

    def build_comment(comment_data)
      comment_factory.new(comment_data["data"])
    end

    def collect_subreddits(comments, count, subreddits)
      comments.each do |comment|
        subreddits[comment.subreddit_name] = true
        break if subreddits.length == count
      end
    end

  end
end

