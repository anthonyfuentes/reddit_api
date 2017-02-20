
module RedditApi
  class Comments

    MAX_FAILURES = 5

    def initialize(args = {})
      @client = args.fetch(:client, RedditApi::Client.new)
      @comment_factory = RedditApi::Comment
      @offset = nil
      @failures = 0
    end

    def most_recent_subreddits(user, count)
      subreddits = {}
      while subreddits.length < count && failures < MAX_FAILURES
        comments = most_recent_comments(user, 100, offset)
        update_progress(comments)
        collect_subreddits(comments, count, subreddits)
      end
      subreddits.keys
    end

    def most_recent_comments(user, count = 100, offset = nil)
      comments_data = most_recent_comment_data(user.username, count, offset)
      build_all_comments(comments_data)
    end

    protected
    attr_writer :offset
    private
    attr_reader :client, :comment_factory, :offset, :failures

    def update_progress(comments)
      if offset == comments.last.reddit_id
        failures += 1
      else
        self.offset = comments.last.reddit_id
      end
    end

    def most_recent_comment_data(username, count, offset)
      return [] if username == "[deleted]"
      endpoint = "user/#{username}/comments.json"
      client.get(endpoint, count, :comment, offset)
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
