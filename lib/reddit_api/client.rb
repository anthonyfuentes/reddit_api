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

    attr_reader :agent, :id, :password, :secret, :username, :failures

    MAX_FAILURES = 5
    ERROR_CODES = (400..511)
    SLEEP_TIME = self.sleep_time

    def initialize(args = {})
      @client = args.fetch(:client, HTTParty)
      @requestor = args.fetch(:requestor, RedditApi::Requestor.new(client: client))
      @failures = args.fetch(:failures, 0)
      @null_response_factory = RedditApi:: NullResponse
      @last_record = nil
    end

    def get(endpoint, count, resource_type, offset = nil)
      if count > 1
        get_many(endpoint, count, resource_type, offset)
      else
        get_one(endpoint, count, resource_type)
      end
    end

    protected
    attr_writer :failures, :last_record
    private
    attr_reader :client, :base_url, :null_response_factory, :last_record,
                :requestor

    def get_many(endpoint, count, resource_type, offset)
      sleep(SLEEP_TIME)
      records = {}
      self.last_record = offset
      while !break_get?(records, count)
        new_records = request_records(endpoint, count, resource_type)
        collect_records(new_records, records, count)
      end
      self.last_record = nil
      records.keys
    end

    def get_one(endpoint, count, resource_type)
      request_records(endpoint, count, resource_type)
    end

    def collect_records(new_records, collected_records, count)
      new_records.each do |record|
        collected_records[record] = true
        break if collected_records.length == count
      end
    end

    def request_records(endpoint, count, resource_type)
      response = send_request(endpoint, resource_type)
      parse_response(response, count)
    end

    def send_request(endpoint, resource_type)
      request = requestor.build(endpoint, resource_type, last_record)
      response = client.get(*request)
      response || null_response_factory.new
    end

    def parse_response(response, count)
      if bad_response?(response)
        handle_bad_response(count)
      else
        handle_successful_response(response, count)
      end
    end

    def bad_response?(response)
      ERROR_CODES.cover?(response.code) || response["error"]
    end

    def handle_bad_response(count)
      self.failures += 1
      if count > 1
        []
      else
        nil
      end
    end

    def handle_successful_response(response, count)
      if count > 1
        handle_plural_response(response)
      else
        response
      end
    end

    def handle_plural_response(response)
      if records = response["data"]["children"]
        store_last_record(records)
      else
        handle_bad_response
      end
    end

    def store_last_record(records)
      self.last_record = records[-1]
      records
    end

    def break_get?(records, desired_count)
      records.length >= desired_count || failures >= MAX_FAILURES
    end

  end
end
