
module RedditApi
  class Subreddits

    def initialize
      @client = RedditApi::Client.new
      @subreddit_factory = RedditApi::Subreddit
      @query_factory =  RedditApi::Query
    end

    def top(count)
      subreddits_data = top_data(count)
      build_all_subreddits(subreddits_data)
    end

    def data_for(subreddit_name)
      query = build_singular_query(subreddit_name)
      client.get(query)
      build_subreddit(query.captured_records.first)
    end

    private
    attr_reader :client, :subreddit_factory, :query_factory

    def top_data(count)
      query = build_plural_query(count)
      client.get(query)
      query.captured_records
    end

    def build_plural_query(count)
      endpoint = "subreddits/popular.json"
      query_factory.new(count: count,
                        endpoint: endpoint,
                        resource: :subreddit)
    end

    def build_singular_query(subreddit_name)
      endpoint = "r/#{subreddit_name}/about.json"
      query_factory.new(count: 1,
                        endpoint: endpoint,
                        resource: :subreddit)
    end

    def build_all_subreddits(subreddits_data)
      subreddits_data.map! do |subreddit_data|
        build_subreddit(subreddit_data["data"])
      end
    end

    def build_subreddit(subreddit_data)
      subreddit_factory.new(subreddit_data)
    end

  end
end
