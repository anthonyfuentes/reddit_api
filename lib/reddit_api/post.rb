
module RedditApi
  class Post

    attr_reader :reddit_id, :author, :subreddit, :stickied

    def initialize(args = {})
      @reddit_id = args.fetch("id", nil)
      @author = args.fetch("author", nil)
      @subreddit = args.fetch("subreddit", nil)
      @stickied = args.fetch("stickied", nil)
    end

    def to_h
      {
        reddit_id: reddit_id,
        author: author,
        subreddit: subreddit,
        stickied: stickied
      }
    end

  end
end
