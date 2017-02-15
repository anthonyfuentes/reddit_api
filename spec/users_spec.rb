require "spec_helper"

describe RedditApi::Users do

  describe "#top_posters" do
    it "returns n authors of the top posts from a subreddit" do
      users_api = RedditApi::Users.new
      subreddit_params = { "display_name" => "AskReddit" }
      subreddit = RedditApi::Subreddit.new(subreddit_params)

      result = users_api.top_posters(subreddit, 5)

      expect(result.length).to eq(5)
    end
  end

end
