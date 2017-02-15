
module RedditApi
  class Comment

    attr_reader :author_name, :subreddit_name

    def initialize(args = {})
      @author_name = args.fetch("author", nil)
      @subreddit_name = args.fetch("subreddit", nil)
    end

    def to_h
      {
        author_name: author_name,
        subreddit_name: subreddit_name
      }
    end

  end
end
