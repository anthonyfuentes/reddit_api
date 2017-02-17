require "spec_helper"

describe RedditApi::Subreddit do

  describe "#reddit_id" do
    it "returns the subreddit's reddit_id" do
      reddit_id = "AskReddit"
      params = { "id" => reddit_id }
      subreddit = RedditApi::Subreddit.new(params)

      expect(subreddit.reddit_id).to eq(reddit_id)
    end
  end

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

  describe "#subreddit_icon" do
    it "returns the subreddit's icon" do
      icon = "img"
      params = { "header_img" => icon }
      subreddit = RedditApi::Subreddit.new(params)

      expect(subreddit.icon).to eq(icon)
    end
  end

  describe "#category" do
    it "returns the subreddit's category" do
      category = "img"
      params = { "advertiser_category" => category }
      subreddit = RedditApi::Subreddit.new(params)

      expect(subreddit.category).to eq(category)
    end
  end

  describe "#active_users" do
    it "returns the subreddit's active users" do
      active_users = 2
      params = { "accounts_active" => active_users }
      subreddit = RedditApi::Subreddit.new(params)

      expect(subreddit.active_users).to eq(active_users)
    end
  end

  describe "#nsfw" do
    it "returns the subreddit's nsfw status" do
      nsfw = false
      params = { "over18" => nsfw }
      subreddit = RedditApi::Subreddit.new(params)

      expect(subreddit.nsfw).to eq(nsfw)
    end
  end

  describe "#to_h" do
    it "returns a hash representation of the subreddit" do
      subreddit = RedditApi::Subreddit.new

      expect(subreddit.to_h).to be_a(Hash)
    end
  end

end
