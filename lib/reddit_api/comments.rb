
module RedditApi
  class Comments

    def initialize
      @client = RedditApi::Client.new
      @comment_factory = RedditApi::Comment
    end

    def most_recent_subreddits(user, count)
      subreddits = {}
      while subreddits.length < count
        comments = most_recent_comments(user)
        collect_subreddits(comments, count, subreddits)
      end
      subreddits.keys
    end

    def most_recent_comments(user, count = 100)
      comments_data = most_recent_comment_data(user.username, count)
      build_all_comments(comments_data)
    end

    private
    attr_reader :client, :comment_factory

    def most_recent_comment_data(username, count)
      return [] if username == "[deleted]"
      endpoint = "user/#{username}/comments.json"
      client.get(endpoint, count, :comment)
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
