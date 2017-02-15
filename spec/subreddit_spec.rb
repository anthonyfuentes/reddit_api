require "spec_helper"

describe RedditApi::Subreddit do

  describe "#name" do
    it "returns the subreddit's name" do
      name = "AskReddit"
      params = { "display_name" => name }
      subreddit = RedditApi::Subreddit.new(params)

      expect(subreddit.name).to eq(name)
    end
  end

  describe "#url" do
    it "returns the subreddit's url" do
      url = "r/AskReddit"
      params = { "url" => url }
      subreddit = RedditApi::Subreddit.new(params)

      expect(subreddit.url).to eq(url)
    end
  end

  describe "#description" do
    it "returns the subreddit's description" do
      description = "Description"
      params = { "public_description" => description }
      subreddit = RedditApi::Subreddit.new(params)

      expect(subreddit.description).to eq(description)
    end
  end

  describe "#subscriber_count" do
    it "returns the subreddit's subscriber_count" do
      subscriber_count = 10
      params = { "subscribers" => subscriber_count }
      subreddit = RedditApi::Subreddit.new(params)

      expect(subreddit.subscriber_count).to eq(subscriber_count)
    end
  end

  describe "#to_h" do
    it "returns a hash representation of the subreddit" do
      subreddit = RedditApi::Subreddit.new

      expect(subreddit.to_h).to be_a(Hash)
    end
  end

end
