require "spec_helper"
require "doubles/response"

describe RedditApi::ResponseParser do

  context "response with error code" do
    describe "#parse_response" do
      it "returns an empty object" do
        response = ResponseStub.new(code: 404)
        parser = RedditApi::ResponseParser

        response = parser.parse_response(response, 10)

        expect(response).to be_empty
      end
    end
  end

  context "response with a truthy error attribute" do
    describe "#parse_response" do
      it "returns an empty object" do
        response = ResponseStub.new(error: true)
        parser = RedditApi::ResponseParser

        response = parser.parse_response(response, 10)

        expect(response).to be_empty
      end
    end
  end

  context "good plural response" do
    describe "#parse_response" do
      it "returns the children attribute of the data hash of the response" do
        response_data = { "children" => [:a, :b, :c] }
        response = ResponseStub.new(data: response_data)
        parser = RedditApi::ResponseParser

        response = parser.parse_response(response, 10)

        expect(response).to eq(response_data["children"])
      end
    end
  end

  context "good singular response" do
    describe "#parse_response" do
      it "returns the data attribute of the response" do
        data = :a
        response = ResponseStub.new(data: :a)
        parser = RedditApi::ResponseParser

        response = parser.parse_response(response, 1)

        expect(response).to eq(data)
      end
    end
  end

end
