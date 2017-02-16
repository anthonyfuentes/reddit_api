require "httparty"

module RedditApi
  class Client

    attr_reader :agent, :id, :password, :secret, :username, :failures

    MAXIMUM_RECORDS = 100
    MAX_FAILURES = 5
    ERROR_CODES = (400..511)

    def initialize(args = {})
      @agent = ENV["REDDIT_AGENT"]
      @client = args.fetch(:client, HTTParty)
      @id = ENV["REDDIT_AGENT"]
      @password = ENV["REDDIT_AGENT"]
      @secret = ENV["REDDIT_AGENT"]
      @username = ENV["REDDIT_AGENT"]
      @base_url = "https://oauth.reddit.com/"
      @failures = args.fetch(:failures, 0)
      @null_response_factory = RedditApi:: NullResponse
      @last_record = nil
    end

    def get(endpoint, count, resource_type)
      sleep(3)
      records = {}
      loop do
        new_records = request_records(endpoint, resource_type)
        collect_records(new_records, records, count)
        break if break_get?(records, count)
      end
      self.last_record = nil
      records.keys
    end

    protected
    attr_writer :failures, :last_record
    private
    attr_reader :client, :base_url, :null_response_factory, :last_record

    def collect_records(new_records, collected_records, count)
      new_records.each do |record|
        collected_records[record] = true
        break if collected_records.length == count
      end
    end

    def request_records(endpoint, resource_type)
      response = send_request(endpoint, resource_type)
      parse_response(response)
    end

    def send_request(endpoint, resource_type)
      url = base_url + endpoint
      headers = generate_headers
      query = generate_query(resource_type)
      response = client.get(url, headers: headers, query: query)
      response || null_response_factory.new
    end

    def parse_response(response)
      if bad_response?(response)
        handle_bad_response
      else
        handle_successful_response(response)
      end
    end

    def bad_response?(response)
      ERROR_CODES.cover?(response.code) || response["error"]
    end

    def handle_bad_response
      self.failures += 1
      []
    end

    def handle_successful_response(response)
      if records = response["data"]["children"]
        store_last_record(records)
      else
        bad_response
      end
    end

    def store_last_record(records)
      self.last_record = records[-1]
      records
    end

    def break_get?(records, desired_count)
      records.length >= desired_count || failures >= MAX_FAILURES
    end

    def generate_headers
      access_token = generate_access_token
      {
        "Authorization" => "bearer #{access_token}",
        "user-agent" => agent
      }
    end

    def generate_query(resource_type)
      {
        limit: MAXIMUM_RECORDS,
        after: generate_after(resource_type)
      }
    end

    def generate_after(resource_type)
      if last_record
        build_after(resource_type)
      else
        nil
      end
    end

    def build_after(resource_type)
      prefix = TYPE_PREFIXES[resource_type]
      last_resource_id = last_record["data"]["id"]
      "#{prefix}_#{last_resource_id}"
    end

    def generate_access_token
      url = "https://www.reddit.com/api/v1/access_token"
      basic_auth = { username: id,
                     password: secret }
      headers = { "user-agent" => agent }
      body = { grant_type:  "password",
               username:  username,
               password: password }
      response = client.post(url,
                             basic_auth: basic_auth,
                             headers: headers,
                             body: body)
      response["access_token"]
    end

  end
end
