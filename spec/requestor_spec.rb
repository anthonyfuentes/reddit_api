require "spec_helper"

describe RedditApi::Requestor, :vcr do

  describe "build" do
    it "returns an array representing an api request" do
      requestor = RedditApi::Requestor.new

      request = requestor.build("endpoint", :subreddit)

      expect(request).to be_a(Array)
    end
  end

end
