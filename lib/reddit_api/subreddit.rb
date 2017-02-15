
module RedditApi
  class Subreddit
    attr_reader :name, :url, :description, :subscriber_count

    def initialize(args = {})
      @name = args.fetch("display_name", nil)
      @url = args.fetch("url", nil)
      @description = args.fetch("public_description", nil)
      @subscriber_count = args.fetch("subscribers", nil)
    end

    def to_h
      {
        name: name,
        url: url,
        description: description,
        subscriber_count: subscriber_count
      }
    end

  end
end
