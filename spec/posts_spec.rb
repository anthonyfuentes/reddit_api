require "spec_helper"

describe RedditApi::Posts do

  context "when count within single api request limit of 100" do
    describe "#top" do
      it "returns n top posts of a subreddit" do
        posts_api = RedditApi::Posts.new
        subreddit_params = { "display_name" => "AskReddit" }
        subreddit = RedditApi::Subreddit.new(subreddit_params)
        count = 5

        posts = posts_api.top(subreddit, count)

        expect(posts.length).to eq(count)
      end

      it "posts are unique" do
        posts_api = RedditApi::Posts.new
        subreddit_params = { "display_name" => "AskReddit" }
        subreddit = RedditApi::Subreddit.new(subreddit_params)
        count = 5

        posts = posts_api.top(subreddit, count)
        unique_posts = posts.uniq { |p| p.reddit_id }

        expect(unique_posts.length).to eq(count)
      end

      it "excludes stickied posts that are included by default" do
        posts_api = RedditApi::Posts.new
        subreddit_params = { "display_name" => "AskReddit" }
        subreddit = RedditApi::Subreddit.new(subreddit_params)

        posts = posts_api.top(subreddit, 5)

        stickied = posts.any? { |p| p.stickied }
        expect(stickied).to be false
      end

      it "returns post objects" do
        posts_api = RedditApi::Posts.new
        subreddit_params = { "display_name" => "AskReddit" }
        subreddit = RedditApi::Subreddit.new(subreddit_params)

        posts = posts_api.top(subreddit, 5)
        all_post_objects = posts.all? { |p| p.is_a?(RedditApi::Post) }

        expect(all_post_objects).to be true
      end
    end
  end

  context "when count greater than single api request limit of 100" do
    describe "#top" do
      it "returns n top posts of a subreddit" do
        posts_api = RedditApi::Posts.new
        subreddit_params = { "display_name" => "AskReddit" }
        subreddit = RedditApi::Subreddit.new(subreddit_params)
        count = 125

        posts = posts_api.top(subreddit, count)

        expect(posts.length).to eq(count)
      end

      it "posts are unique" do
        posts_api = RedditApi::Posts.new
        subreddit_params = { "display_name" => "AskReddit" }
        subreddit = RedditApi::Subreddit.new(subreddit_params)
        count = 125

        posts = posts_api.top(subreddit, count)
        unique_posts = posts.uniq { |p| p.reddit_id }

        expect(unique_posts.length).to eq(count)
      end
    end
  end

end
