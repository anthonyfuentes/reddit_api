require "spec_helper"
require "doubles/client"
require "doubles/response"
require "doubles/record"

describe RedditApi::Client, :vcr do

  describe "#initialize" do
    it "defaults failures to 0" do
      client = RedditApi::Client.new

      expect(client.failures).to eq(0)
    end

    it "defaults max failures to DEFAULT_MAX_FAILURES" do
      max_failure_default = RedditApi::Client::DEFAULT_MAX_FAILURES
      client = RedditApi::Client.new

      expect(client.max_failures).to eq(max_failure_default)
    end
  end

  describe "#failures" do
    it "returns number of failures for the query in progress" do
      failures = 3
      client = RedditApi::Client.new(failures: failures)

      expect(client.failures).to eq(failures)
    end
  end

  describe "#max_failures" do
    it "returns failure limit" do
      max_fail = 0
      client = RedditApi::Client.new(max_fail: max_fail)

      expect(client.max_failures).to eq(max_fail)
    end
  end

  describe "#get" do
    it "uses external client to send get request" do
      records = Array.new(2) { |i| RecordStub.new(id: i) }
      response_data = { "children" =>  records }
      response = ResponseStub.new(data: response_data)
      external_client = ExternalClientStub.new(response: response)
      client = RedditApi::Client.new(client: external_client)
      query = RedditApi::Query.new(count: 2)

      expect(external_client).to receive(:get).and_return(response)
      client.get(query)
    end

    it "does not iterate if failures is >= max failures" do
      max_failures = RedditApi::Client::DEFAULT_MAX_FAILURES
      records = Array.new(2) { |i| RecordStub.new(id: i) }
      response_data = { "children" =>  records }
      response = ResponseStub.new(data: response_data)
      external_client = ExternalClientStub.new(response: response)
      client = RedditApi::Client.new(client: external_client,
                                     failures: max_failures)
      query = RedditApi::Query.new(count: 2)

      client.get(query)

      expect(query.capture_count).to eq(0)
    end

    it "resets failures to 0 after collecting records" do
      max_failures = RedditApi::Client::DEFAULT_MAX_FAILURES
      external_client = ExternalClientStub.new
      client = RedditApi::Client.new(client: external_client,
                                     failures: max_failures)
      query = RedditApi::Query.new(count: 100)

      client.get(query)

      expect(client.failures).to eq(0)
    end

    it "resources are unique" do
      unique_count = 110
      records = Array.new(unique_count) { |i| RecordStub.new(id: i) }
      response_data = { "children" =>  records + records.dup }
      response = ResponseStub.new(data: response_data)
      external_client = ExternalClientStub.new(response: response)
      client = RedditApi::Client.new(client: external_client)
      query = RedditApi::Query.new(count: 125)

      client.get(query)
      unique_resources = query.captured_records.uniq do |r|
        r["data"]["id"]
      end

      expect(unique_resources.length).to eq(unique_count)
    end
  end

  context "when count within single api request limit of 100" do
    describe "#get" do
      it "returns n resources from a given endpoint" do
        client = RedditApi::Client.new
        query = RedditApi::Query.new(count: 99,
                                     resource_type: :subreddit,
                                     endpoint: "subreddits/popular.json")

        client.get(query)

        expect(query.capture_count).to eq(query.count)
      end
    end
  end

  context "when count greater than single api request limit of 100" do
    describe "#get" do
      it "returns n resources from a given endpoint" do
        client = RedditApi::Client.new
        query = RedditApi::Query.new(count: 125,
                                     resource: :subreddit,
                                     endpoint: "subreddits/popular.json")

        client.get(query)

        expect(query.capture_count).to eq(query.count)
      end
    end
  end

end


