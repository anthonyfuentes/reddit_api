
module RedditApi
  class Subreddits

    def initialize
      @client = RedditApi::Client.new
      @subreddit_factory = RedditApi::Subreddit
    end

    def top(count)
      subreddits_data = top_data(count)
      build_all_subreddits(subreddits_data)
    end

    private
    attr_reader :client, :subreddit_factory

    def top_data(count)
      endpoint = "subreddits/popular.json"
      query = { limit: count }
      response = client.get(endpoint, query)
      extract_top_data(response["data"])
    end

    def extract_top_data(response_data)
      response_data["children"]
    end

    def build_all_subreddits(subreddits_data)
      subreddits_data.map! do |subreddit_data|
        build_subreddit(subreddit_data)
      end
    end

    def build_subreddit(subreddit_data)
      subreddit_factory.new(subreddit_data["data"])
    end

  end
end