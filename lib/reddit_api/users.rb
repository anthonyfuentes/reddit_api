module RedditApi
  class Users

    DEFAULT_MAX_MISSES = 2

    attr_reader :misses

    def initialize(args = {})
      @post_api = args.fetch(:posts, RedditApi::Posts.new)
      @user_factory = RedditApi::User
      @misses = args.fetch(:misses, 0)
      @max_misses = args.fetch(:max_miss, DEFAULT_MAX_MISSES)
      @last_count = 0
    end

    def top_posters(subreddit, count)
      users = {}
      while users.length < count && misses < max_misses
        posts = post_api.top(subreddit, count)
        collect_users(posts, count, users)
        update_misses(users.length)
      end
      reset_collection_metrics
      users.values
    end

    protected
    attr_writer :misses, :last_count
    private
    attr_reader :post_api, :user_factory, :last_count, :max_misses

    def collect_users(posts, count, users)
      usernames = get_usernames(posts, count, users)
      user_data = format_user_data(usernames)
      new_users = build_all_users(user_data)
      aggregate_users(new_users, users)
    end

    def get_usernames(posts, count, users)
      usernames = []
      posts.each_with_index do |post, i|
        break if (users.length + i) == count
        usernames << post.author
      end
      usernames
    end

    def format_user_data(usernames)
      usernames.map! do |username|
        { "username" => username }
      end
    end

    def build_all_users(users_data)
      users_data.map! do |user_data|
        build_user(user_data)
      end
    end

    def build_user(user_data)
      user_factory.new(user_data)
    end

    def aggregate_users(new_users, collected_users)
      self.last_count = collected_users.length
      new_users.each do |user|
        collected_users[user.username] = user
      end
    end

    def update_misses(new_count)
      if (new_count - last_count).zero?
        self.misses += 1
      end
    end

    def reset_collection_metrics
      self.misses = 0
      self.last_count = 0
    end

  end
end

