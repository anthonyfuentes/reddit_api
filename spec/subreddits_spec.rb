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

    it "returns subreddit objects" do
      subreddit_api = RedditApi::Subreddits.new

      subreddits = subreddit_api.top(5)
      all_subreddit_objects = subreddits.all? do |s|
        s.is_a?(RedditApi::Subreddit)
      end

      expect(all_subreddit_objects).to be true
    end
  end

end
