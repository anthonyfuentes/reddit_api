
module RedditApi
  class Requestor

      MAXIMUM_RECORDS = 100
      AGENT = ENV["REDDIT_AGENT"]
      ID = ENV["REDDIT_AGENT"]
      PASSWORD = ENV["REDDIT_AGENT"]
      SECRET = ENV["REDDIT_AGENT"]
      USERNAME = ENV["REDDIT_AGENT"]
      BASE_URL = "https://oauth.reddit.com/"

      def initialize(args = {})
        @client = args.fetch(:client, HTTParty)
      end

      def build(endpoint, resource_type, last_record = nil)
        url = BASE_URL + endpoint
        headers = generate_headers
        query = generate_query(resource_type, last_record)
        [url, { headers: headers, query: query }]
      end

      private
      attr_reader :client

      def generate_headers
        access_token = generate_access_token
        {
          "Authorization" => "bearer #{access_token}",
          "user-agent" => AGENT
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
        basic_auth = { username: ID,
                       password: SECRET }
        headers = { "user-agent" => AGENT }
        body = { grant_type:  "password",
                 username:  USERNAME,
                 password: PASSWORD }
        response = client.post(url,
                               basic_auth: basic_auth,
                               headers: headers,
                               body: body)
        response["access_token"]
      end

  end
end
