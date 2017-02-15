require "spec_helper"

describe RedditApi::Posts do

  describe "#top" do
    it "returns n top posts of a subreddit" do
      posts_api = RedditApi::Posts.new
      subreddit_params = { "display_name" => "AskReddit" }
      subreddit = RedditApi::Subreddit.new(subreddit_params)

      result = posts_api.top(subreddit, 5)

      expect(result.length).to eq(5)
    end

    it "excludes stickied posts that are included by default" do
      posts_api = RedditApi::Posts.new
      subreddit_params = { "display_name" => "AskReddit" }
      subreddit = RedditApi::Subreddit.new(subreddit_params)

      result = posts_api.top(subreddit, 5)

      stickied = result.any? { |p| p.stickied }
      expect(stickied).to be false
    end
  end

end
