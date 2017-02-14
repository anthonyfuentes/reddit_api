require "spec_helper"

describe RedditApi::Client do

  context "when ready to make requests" do
    describe "#agent" do
      it "returns client agent" do
        client = RedditApi::Client.new
        expect(client.agent).to_not be_nil
      end
    end

    describe "#id" do
      it "returns client id" do
        client = RedditApi::Client.new
        expect(client.id).to_not be_nil
      end
    end

    describe "#password" do
      it "returns client password" do
        client = RedditApi::Client.new
        expect(client.password).to_not be_nil
      end
    end

    describe "#secret" do
      it "returns client secret" do
        client = RedditApi::Client.new
        expect(client.secret).to_not be_nil
      end
    end

    describe "#username" do
      it "returns client username" do
        client = RedditApi::Client.new
        expect(client.username).to_not be_nil
      end
    end
  end

end

