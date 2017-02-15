require "spec_helper"

describe RedditApi::Post do

  describe "#author" do
    it "returns the post's author" do
      author = "Somebody"
      params = { "author" => author }
      post = RedditApi::Post.new(params)

      expect(post.author).to eq(author)
    end
  end

  describe "#subreddit" do
    it "returns the subreddit where the post was made" do
      subreddit = "AskReddit"
      params = { "subreddit" => subreddit }
      post = RedditApi::Post.new(params)

      expect(post.subreddit).to eq(subreddit)
    end
  end

  describe "#stickied" do
    it "returns the post's sticky status" do
      stickied = true
      params = { "stickied" => stickied }
      post = RedditApi::Post.new(params)

      expect(post.stickied).to eq(stickied)
    end
  end

  describe "#to_h" do
    it "returns a hash representation of the post" do
      post = RedditApi::Post.new

      expect(post.to_h).to be_a(Hash)
    end
  end

end
