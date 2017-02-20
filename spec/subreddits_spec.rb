require "spec_helper"

describe RedditApi::Subreddits, :vcr do

  context "when count within single api request limit of 100" do
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

    describe "#data_for" do
      it "returns Subreddit object representing the given subreddit" do
        subreddit = double()
        allow(subreddit).to receive(:name).and_return("AskReddit")
        subreddit_api = RedditApi::Subreddits.new

        subreddit = subreddit_api.data_for(subreddit)

        expect(subreddit).to be_a(RedditApi::Subreddit)
      end
    end
  end

  context "when count greater than single api request limit of 100" do
    describe "#top" do
      it "returns an array of the top n subreddits" do
        subreddit_api = RedditApi::Subreddits.new
        count = 125

        result = subreddit_api.top(count)

        expect(result.length).to eq(count)
      end

      it "subreddits are unique" do
        subreddit_api = RedditApi::Subreddits.new
        count = 125

        subreddits = subreddit_api.top(count)
        unique_subreddits = subreddits.uniq { |s| s.reddit_id }

        expect(unique_subreddits.length).to eq(count)
      end
    end
  end

end
