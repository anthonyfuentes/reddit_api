require "spec_helper"

describe RedditApi::Users do

  describe "#top_posters" do
    it "returns n authors of the top posts from a subreddit" do
      users_api = RedditApi::Users.new
      count = 5
      subreddit = RedditApi::Subreddit.new({ "display_name" => "AskReddit" })

      result = users_api.top_posters(subreddit, count)

      expect(result.length).to eq(count)
    end

    it "returns user objects" do
      users_api = RedditApi::Users.new
      subreddit = RedditApi::Subreddit.new({ "display_name" => "AskReddit" })

      result = users_api.top_posters(subreddit, 5)
      all_user_objects = result.all? { |u| u.is_a?(RedditApi::User) }

      expect(all_user_objects).to be true
    end

    it "returns unique users" do
      users_api = RedditApi::Users.new
      count = 5
      subreddit = RedditApi::Subreddit.new({ "display_name" => "AskReddit" })

      result = users_api.top_posters(subreddit, count)
      unique_users = result.uniq { |u| u.username }

      expect(unique_users.length).to eq(count)
    end

    it "returns if misses is equal to max misses" do
      misses = RedditApi::Users::MAX_MISSES
      users_api = RedditApi::Users.new(misses: misses)
      subreddit = RedditApi::Subreddit.new({ "display_name" => "AskReddit" })

      result = users_api.top_posters(subreddit, 10)

      expect(result.length).to eq(0)
    end
  end

end
