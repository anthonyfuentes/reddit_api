require "spec_helper"
require "doubles/posts"

describe RedditApi::Users, :vcr do

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
      misses = RedditApi::Users::DEFAULT_MAX_MISSES
      users_api = RedditApi::Users.new(misses: misses)
      subreddit = RedditApi::Subreddit.new({ "display_name" => "AskReddit" })

      result = users_api.top_posters(subreddit, 10)

      expect(result.length).to eq(0)
    end

    it "resets misses to 0 after collecting users" do
      max_misses = RedditApi::Users::DEFAULT_MAX_MISSES
      users_api = RedditApi::Users.new(misses: max_misses)
      subreddit = RedditApi::Subreddit.new({ "display_name" => "AskReddit" })

      users_api.top_posters(subreddit, 99)

      expect(users_api.misses).to eq(0)
    end

    it "returns an empty array if the subreddit does not exist" do
      users_api = RedditApi::Users.new
      subreddit = RedditApi::Subreddit.new({ "display_name" => "9" })

      posters = users_api.top_posters(subreddit, 99)

      expect(posters).to eq([])
    end

    it "increments misses if no users are added" do
      posts_api = PostsStub.new
      response =  PostsStub::DEFAULT_RESPONSE
      users_api = RedditApi::Users.new(posts: posts_api)
      subreddit = RedditApi::Subreddit.new({ "display_name" => "9" })

      expect(posts_api).to receive(:top).and_return(response, response, response)
      posters = users_api.top_posters(subreddit, 5)

      expect(posters.length).to eq(1)
    end
  end
end
