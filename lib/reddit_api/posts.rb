
module RedditApi
  class Posts

    def initialize
      @client = RedditApi::Client.new
      @post_factory = RedditApi::Post
    end

    def top(subreddit, count)
      posts_data = top_data(subreddit, count)
      posts_data = filter_out(posts_data, :stickied_posts)
      build_all_posts(posts_data)
    end

    private
    attr_reader :client, :post_factory

    def top_data(subreddit, count)
      endpoint = URI.encode("r/#{subreddit.name}/hot.json")
      client.get(endpoint, count)
    end

    def filter_out(posts_data, filter)
      send(filter, posts_data)
    end

    def stickied_posts(posts_data)
      posts_data.select do |post_data|
        !post_data["data"]["stickied"]
      end
    end

    def build_all_posts(posts_data)
      posts_data.map! do |post_data|
        build_post(post_data)
      end
    end

    def build_post(post_data)
      post_factory.new(post_data["data"])
    end

  end
end
