require "spec_helper"

describe RedditApi::NullResponse do

  describe "#code" do
    it "returns 404" do
      null_response = RedditApi::NullResponse.new

      code = null_response.code

      expect(code).to eq(404)
    end
  end

end
