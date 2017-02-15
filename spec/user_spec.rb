require "spec_helper"

describe RedditApi::User do

  describe "#username" do
    it "returns user's username" do
      username = "spez"
      user_params = { "username" => username }
      user = RedditApi::User.new(user_params)

      expect(user.username).to eq(username)
    end
  end

end
