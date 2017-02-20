require "spec_helper"

describe RedditApi::Client, :vcr do

  context "when initialized" do
    describe "#failures" do
      it "returns the client's number of failures" do
        failures = 2
        client = RedditApi::Client.new(failures: failures)
        expect(client.failures).to eq(failures)
      end

      it "defaults to 0" do
        client = RedditApi::Client.new()
        expect(client.failures).to eq(0)
      end
    end
  end

  context "when count within single api request limit of 100" do
    describe "#get" do
      it "uses external client to send get request" do
        external_client = double()
        response = double()
        response_data = Array(1..10)
        all_responses = [false, false, { "children" => response_data }]
        allow(response).to receive(:code).and_return(200)
        allow(response).to receive(:[]).and_return(*all_responses)
        allow(external_client).to receive(:post).and_return(response)
        client = RedditApi::Client.new(client: external_client)

        expect(external_client).to receive(:get).and_return(response)

        client.get("url", 10, :subreddit)
      end

      it "returns n resources from a given endpoint" do
        client = RedditApi::Client.new
        url = "subreddits/popular.json"
        count = 10

        resources = client.get(url, count, :subreddit)

        expect(resources.length).to eq(count)
      end

      it "resources are unique" do
        client = RedditApi::Client.new
        url = "subreddits/popular.json"
        count = 10

        resources = client.get(url, count, :subreddit)
        unique_resources = resources.uniq { |r| r["data"]["id"] }

        expect(unique_resources.length).to eq(count)
      end
    end
  end

  context "when count greater than single api request limit of 100" do
    describe "#get" do
      it "can return more than the 100 api call limit" do
        client = RedditApi::Client.new
        url = "subreddits/popular.json"
        count = 150

        resources = client.get(url, count, :subreddit)

        expect(resources.length).to eq(count)
      end

      it "resources are unique" do
        client = RedditApi::Client.new
        url = "subreddits/popular.json"
        count = 150

        resources = client.get(url, count, :subreddit)
        unique_resources = resources.uniq { |r| r["data"]["id"] }

        expect(unique_resources.length).to eq(count)
      end
    end
  end

end


