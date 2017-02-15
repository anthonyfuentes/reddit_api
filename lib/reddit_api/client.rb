require "httparty"

module RedditApi
  class Client

    attr_reader :agent, :id, :password, :secret, :username

    def initialize(args = {})
      @agent = ENV["REDDIT_AGENT"]
      @client = args.fetch(:client, HTTParty)
      @id = ENV["REDDIT_AGENT"]
      @password = ENV["REDDIT_AGENT"]
      @secret = ENV["REDDIT_AGENT"]
      @username = ENV["REDDIT_AGENT"]
      @base_url = "https://oauth.reddit.com/"
    end

    def get(endpoint, query)
      sleep(1)
      headers = { "Authorization" => "bearer #{access_token}",
                  "user-agent" => agent }
      url = base_url + endpoint
      client.get(url, headers: headers, query: query)
    end

    private
    attr_reader :client, :base_url

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
