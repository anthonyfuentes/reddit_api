
module RedditApi
  class Comment

    attr_reader :reddit_id, :author_name, :subreddit_name

    def initialize(args = {})
      @reddit_id = args.fetch("id", nil)
      @author_name = args.fetch("author", nil)
      @subreddit_name = args.fetch("subreddit", nil)
    end

    def to_h
      {
        reddit_id: reddit_id,
        author_name: author_name,
        subreddit_name: subreddit_name
      }
    end

  end
end
