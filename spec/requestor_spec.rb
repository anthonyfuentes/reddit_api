require "spec_helper"

describe RedditApi::Requestor, :vcr do

  describe "build" do
    it "returns an array representing an api request" do
      requestor = RedditApi::Requestor.new
      query = RedditApi::Query.new()

      request = requestor.build(query)

      expect(request).to be_a(Array)
    end
  end

end
