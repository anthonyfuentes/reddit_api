require "httparty"

module RedditApi
  class Client

    attr_reader :agent, :id, :password, :secret, :username

    def initialize
      @agent = ENV["REDDIT_AGENT"]
      @client = HTTParty
      @id = ENV["REDDIT_AGENT"]
      @password = ENV["REDDIT_AGENT"]
      @secret = ENV["REDDIT_AGENT"]
      @username = ENV["REDDIT_AGENT"]
    end

  end
end
