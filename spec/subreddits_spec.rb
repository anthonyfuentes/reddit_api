require "spec_helper"

describe RedditApi::Subreddits do

  describe "#top" do
    it "returns an array of the top n subreddits" do
      subreddit_api = RedditApi::Subreddits.new
      count = 5

      result = subreddit_api.top(count)

      expect(result.length).to eq(5)
    end

    it "subreddits are unique" do
      subreddit_api = RedditApi::Subreddits.new
      count = 5

      subreddits = subreddit_api.top(count)
      unique_subreddits = subreddits.uniq { |s| s.reddit_id }

      expect(unique_subreddits.length).to eq(count)
    end
  end

end
