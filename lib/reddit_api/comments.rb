
module RedditApi
  class Comments

    MAX_FAILURES = 5

    def initialize(args = {})
      @client = args.fetch(:client, RedditApi::Client.new)
      @comment_factory = RedditApi::Comment
      @query_factory =  RedditApi::Query
      @offset = nil
      @failures = 0
    end

    def most_recent_subreddits(user, count)
      self.failures = 0
      subreddits = {}
      loops = 0
      while subreddits.length < count &&
          failures < MAX_FAILURES &&
          loops < MAX_FAILURES
        comments = most_recent_comments(user, 100, offset)
        update_progress(comments)
        collect_subreddits(comments, count, subreddits)
        loops += 1
      end
      subreddits.keys
    end

    def most_recent_comments(user, count, offset = nil)
      comments_data = most_recent_comment_data(user.username, count, offset)
      build_all_comments(comments_data)
    end

    protected
    attr_accessor :failures
    attr_writer :offset, :failures
    private
    attr_reader :client, :comment_factory, :offset, :query_factory

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

    def update_progress(comments)
      if comments.empty?
        self.failures += 1
      else
        self.offset = comments.last.reddit_id
      end
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
