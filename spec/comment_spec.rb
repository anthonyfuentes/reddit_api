require "spec_helper"

describe RedditApi::Comment do

  describe "#author_name" do
    it "returns the name of comment's author" do
      author_name = "spez"
      params = { "author" => author_name }
      comment = RedditApi::Comment.new(params)

      expect(comment.author_name).to eq(author_name)
    end
  end

  describe "#subreddit_name" do
    it "returns the name of the subreddit where the comment was made" do
      subreddit_name = "AskReddit"
      params = { "subreddit" => subreddit_name }
      comment = RedditApi::Comment.new(params)

      expect(comment.subreddit_name).to eq(subreddit_name)
    end
  end

  describe "#to_h" do
    it "returns a hash representation of the comment" do
      comment = RedditApi::Comment.new

      expect(comment.to_h).to be_a(Hash)
    end
  end

end
