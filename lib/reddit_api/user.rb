
module RedditApi
  class User

    attr_reader :username

    def initialize(args = {})
      @username = args.fetch("username", nil)
    end

    def to_h
      { username: username }
    end

  end
end
