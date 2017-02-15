
module RedditApi
  class Posts

    def initialize
      @client = RedditApi::Client.new
    end

    def top(subreddit, count)
      query = { limit: count }
      endpoint = URI.encode("r/#{subreddit.name}/hot.json")
      response = client.get(endpoint, query)
      filter_out(response, :stickied_posts)
    end

    private
    attr_reader :client

    def filter_out(response, filter)
      if response["error"]
        []
      else
        send(filter, response["data"]["children"])
      end
    end

    def stickied_posts(posts)
      posts.select do |post|
        !post["data"]["stickied"]
      end
    end

  end
end
