require "spec_helper"

describe RedditApi::Posts do

  describe "#top" do
    it "excludes stickied posts that are included by default" do
      posts_api = RedditApi::Posts.new
      subreddit = double()
      allow(subreddit).to receive(:name).and_return("AskReddit")

      result = posts_api.top(subreddit, 5)
      stickied = result.any? { |p| p["data"]["stickied"] }

      expect(stickied).to be false
    end

    it "returns n top posts of a subreddit" do
      posts_api = RedditApi::Posts.new
      subreddit = double()
      allow(subreddit).to receive(:name).and_return("AskReddit")

      result = posts_api.top(subreddit, 5)

      expect(result.length).to eq(5)
    end
  end

end
