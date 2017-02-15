
module RedditApi
  class Users

    def initialize
      @post_api = RedditApi::Posts.new
    end

    def top_posters(subreddit, count)
      posters = {}
      while posters.length < count
        posts = post_api.top(subreddit, count)
        collect_posters(posts, count, posters)
      end
      posters.keys
    end

    private
    attr_reader :post_api

    def collect_posters(posts, count, posters)
      posts.each do |post|
        posters[post.author] = true
        break if posters.length == count
      end
    end

  end
end
