
module RedditApi
  class Post

    attr_reader :author, :subreddit, :stickied

    def initialize(args = {})
      @author = args.fetch("author", nil)
      @subreddit = args.fetch("subreddit", nil)
      @stickied = args.fetch("stickied", nil)
    end

    def to_h
      {
        author: author,
        subreddit: subreddit,
        stickied: stickied
      }
    end

  end
end
