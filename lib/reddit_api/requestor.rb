
module RedditApi
  class Requestor

    def initialize(args = {})
      @agent = ENV["REDDIT_AGENT"]
      @base_url = "https://oauth.reddit.com/"
      @client = args.fetch(:client, HTTParty)
      @id = ENV["REDDIT_ID"]
      @password = ENV["REDDIT_PASSWORD"]
      @secret = ENV["REDDIT_SECRET"]
      @username = ENV["REDDIT_USERNAME"]
    end

    def build(query)
      url = base_url + query.endpoint
      headers = generate_headers
      api_query = generate_query(query)
      [url, { headers: headers, query: api_query }]
    end

    private
    attr_reader :agent, :base_url, :client, :id, :password, :secret, :username

    def generate_headers
      {
        "Authorization" => "bearer #{access_token}",
        "user-agent" => agent
      }
    end

    def generate_query(query)
      {
        limit: query.count,
        after: generate_after(query.resource_type, query.offset_id)
      }
    end

    def generate_after(resource_type, offset_id)
      if offset_id
        build_after(resource_type, offset_id)
      else
        ""
      end
    end

    def build_after(resource_type, offset_id)
      prefix = TYPE_PREFIXES[resource_type]
      "#{prefix}_#{offset_id}"
    end

    def access_token
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
