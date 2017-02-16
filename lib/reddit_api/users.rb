
module RedditApi
  class Users

    def initialize
      @post_api = RedditApi::Posts.new
      @user_factory = RedditApi::User
    end

    def top_posters(subreddit, count)
      users = {}
      while users.length < count
        posts = post_api.top(subreddit, count)
        collect_users(posts, count, users)
      end
      users.values
    end

    private
    attr_reader :post_api, :user_factory

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
      new_users.each do |user|
        collected_users[user.username] = user
      end
    end

  end
end

