
module RedditApi
  class Comment

    attr_reader :author_name

    def initialize(args = {})
      @author_name = args.fetch("author", nil)
    end

    def to_h
      {
        author_name: author_name
      }
    end

  end
end
