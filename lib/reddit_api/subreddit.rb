
module RedditApi
  class Subreddit

    def initialize
      @client = RedditApi::Client.new
    end

    def top(count)
      subreddits_data = top_data(count)
      cleanse_all_data(subreddits_data)
    end

    private
    attr_reader :client

    def top_data(count)
      endpoint = "subreddits/popular.json"
      query = { limit: count }
      response = client.get(endpoint, query)
      response["data"]["children"]
    end

    def cleanse_all_data(subreddits_data)
      subreddits_data.map! do |subreddit_data|
        cleanse_data(subreddit_data)
      end
    end

    def cleanse_data(subreddit_data)
      {
        subscriber_count: subreddit_data["data"]["subscribers"],
        url: subreddit_data["data"]["url"],
        name: subreddit_data["data"]["display_name"],
        description: subreddit_data["data"]["public_description"]
      }
    end

  end
end
