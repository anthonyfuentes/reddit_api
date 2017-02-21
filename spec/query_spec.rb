require "spec_helper"
require "doubles/record"

describe RedditApi::Query do

  describe "#collected_records" do
    it "returns the records captured for the query" do
      records = Array.new(3) { |i| RecordStub.new(id: i) }
      query = RedditApi::Query.new

      query.add_records(records)

      expect(query.collected_records).to eq(records)
    end
  end

  describe "#count" do
    it "returns the count of records to query for" do
      count = 10
      query = RedditApi::Query.new(count: count)

      expect(query.count).to eq(count)
    end
  end

  describe "#endpoint" do
    it "returns the url to query" do
      endpoint = "endpoint.json"
      query = RedditApi::Query.new(endpoint: endpoint)

      expect(query.endpoint).to eq(endpoint)
    end
  end

  describe "#offset" do
    it "returns the offset id of record to offset the query by" do
      offset = "dw8jk"
      query = RedditApi::Query.new(offset: offset)

      expect(query.offset_id).to eq(offset)
    end
  end

  describe "#records_captured" do
    it "returns the number of records captured for the query" do
      records = Array.new(3)
      query = RedditApi::Query.new(records: records)

      expect(query.records_captured).to eq(records.length)
    end
  end

  describe "#resource_type" do
    it "returns the type of the resource to query for" do
      resource_type = :comment
      query = RedditApi::Query.new(resource: resource_type)

      expect(query.resource_type).to eq(resource_type)
    end
  end

  context "count is one" do
    describe "#add_records" do
      it "adds one record to the queries record store" do
        query = RedditApi::Query.new(count: 1)
        record = RecordStub.new

        expect{
          query.add_records(record)
        }.to change(query, :records_captured).by(1)
      end

      it "updates the offset id" do
        query = RedditApi::Query.new(count: 1)
        record = RecordStub.new(id: 0)

        query.add_records(record)

        expect(query.offset_id).to eq(record.id)
      end
    end
  end

  context "count is greater than one" do
    describe "#add_records" do
      it "adds multiple records to the queries record store" do
        query = RedditApi::Query.new
        records = Array.new(3) { |i| RecordStub.new(id: i) }

        expect{
          query.add_records(records)
        }.to change(query, :records_captured).by(records.length)
      end

      it "filters out duplicate records" do
        query = RedditApi::Query.new
        record = RecordStub.new(id: 0)
        records = Array.new(3) { record }

        expect{
          query.add_records(records)
        }.to change(query, :records_captured).by(1)
      end

      it "updates the offset id" do
        query = RedditApi::Query.new
        records = Array.new(3) { |i| RecordStub.new(id: i) }

        query.add_records(records)

        expect(query.offset_id).to eq(records.length - 1)
      end
    end
  end

end

