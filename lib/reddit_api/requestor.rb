
module RedditApi
  class Requestor

    MAXIMUM_RECORDS = 100

    def initialize(args = {})
      @client = args.fetch(:client, HTTParty)
      @agent = ENV["REDDIT_AGENT"]
      @id = ENV["REDDIT_ID"]
      @password = ENV["REDDIT_PASSWORD"]
      @secret = ENV["REDDIT_SECRET"]
      @username = ENV["REDDIT_USERNAME"]
      @base_url = "https://oauth.reddit.com/"
    end

    def build(endpoint, resource_type, last_record = nil)
      url = base_url + endpoint
      headers = generate_headers
      query = generate_query(resource_type, last_record)
      [url, { headers: headers, query: query }]
    end

    private
    attr_reader :agent, :base_url, :id, :password, :secret, :username, :client

    def generate_headers
      access_token = generate_access_token
      {
        "Authorization" => "bearer #{access_token}",
        "user-agent" => agent
      }
    end

    def generate_query(resource_type, last_record)
      {
        limit: MAXIMUM_RECORDS,
        after: generate_after(resource_type, last_record)
      }
    end

    def generate_after(resource_type, last_record)
      if last_record
        build_after(resource_type, last_record)
      else
        ""
      end
    end

    def build_after(resource_type, record)
      prefix = TYPE_PREFIXES[resource_type]
      last_resource_id = record["data"]["id"]
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
