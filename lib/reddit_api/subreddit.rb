
module RedditApi
  class Subreddit
    attr_reader :reddit_id, :name, :url, :description, :subscriber_count

    def initialize(args = {})
      @reddit_id = args.fetch("id", nil)
      @name = args.fetch("display_name", nil)
      @url = args.fetch("url", nil)
      @description = args.fetch("public_description", nil)
      @subscriber_count = args.fetch("subscribers", nil)
    end

    def to_h
      {
        reddit_id: reddit_id,
        name: name,
        url: url,
        description: description,
        subscriber_count: subscriber_count
      }
    end

  end
end
