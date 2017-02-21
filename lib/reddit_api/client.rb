require "httparty"

module RedditApi
  class Client

    def self.sleep_time
      if ENV["ENVIRONMENT"] == "TEST" || ENV["RAILS_ENV"] == "test"
        0
      else
        3
      end
    end

    SLEEP_TIME = self.sleep_time
    MAX_FAILURES = 5

    attr_reader :failures

    def initialize(args = {})
      @client = args.fetch(:client, HTTParty)
      @requestor = args.fetch(:requestor, RedditApi::Requestor.new(client: client))
      @parser = args.fetch(:parser, RedditApi::ResponseParser)
      @null_response_factory = RedditApi:: NullResponse
      @failures = args.fetch(:failures, 0)
    end

    def get(query)
      while query.capture_count < query.count && failures < MAX_FAILURES
        response = send_request(query)
        response = parser.parse_response(response, query.count)
        update_progress(query, response)
      end
      reset_failures
    end

    protected
    attr_writer :failures
    private
    attr_reader :client, :null_response_factory, :requestor, :parser

    def send_request(query)
      request = requestor.build(query)
      response = client.get(*request)
      response || null_response_factory.new
    end

    def update_progress(query, response)
      captured_before = query.capture_count
      update_query(query, response)
      captured_after = query.capture_count
      update_failures(captured_before, captured_after, query.count)
    end

    def update_query(query, response)
      query.add_records(response)
    end

    def update_failures(captured_before, captured_after, count)
      if captured_before >= captured_after
        self.failures += 1
      end
    end

    def reset_failures
      self.failures = 0
    end

  end
end
