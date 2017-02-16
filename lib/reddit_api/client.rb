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
    end

    def get(endpoint, count)
      sleep(3)
      records = {}
      loop do
        record_count = records.length
        new_records = request_records(endpoint, count, record_count)
        collect_records(new_records, records, count)
        break if get_break?(new_records, count)
      end
      records.keys
    end

    protected
    attr_writer :failures
    private
    attr_reader :client, :base_url, :null_response_factory

    def collect_records(new_records, collected_records, count)
      new_records.each do |record|
        collected_records[record] = true
        break if collected_records.length == count
      end
    end

    def request_records(endpoint, desired_count, current_count)
      response = send_request(endpoint, desired_count, current_count)
      parse_response(response)
    end

    def send_request(endpoint, desired_count, current_count)
      url = base_url + endpoint
      headers = generate_headers
      query = generate_query(desired_count, current_count)
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
        records
      else
        bad_response
      end
    end

    def get_break?(records, desired_count)
      records.length >= desired_count || failures >= MAX_FAILURES
    end

    def generate_query(desired_count, current_count)
      {
        limit: MAXIMUM_RECORDS,
        after: "TODO"
      }
    end

    def generate_headers
      access_token = generate_access_token
      {
        "Authorization" => "bearer #{access_token}",
        "user-agent" => agent
      }
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
