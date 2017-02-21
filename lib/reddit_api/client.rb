require "httparty"

module RedditApi
  class Client

    def self.sleep_time
      if ENV["ENVIRONMENT"] == "TEST"
        0
      else
        3
      end
    end

    SLEEP_TIME = self.sleep_time
    DEFAULT_MAX_FAILURES = 2

    attr_reader :failures, :max_failures

    def initialize(args = {})
      @client = args.fetch(:client, HTTParty)
      @requestor = args.fetch(:requestor, RedditApi::Requestor.new(client: client))
      @parser = args.fetch(:parser, RedditApi::ResponseParser)
      @null_response_factory = RedditApi:: NullResponse
      @failures = args.fetch(:failures, 0)
      @max_failures = args.fetch(:max_fail, DEFAULT_MAX_FAILURES)
    end

    def get(query)
      while query.capture_count < query.count && failures < max_failures
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
      sleep(SLEEP_TIME)
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
