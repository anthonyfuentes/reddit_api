
module RedditApi
  class Subreddit
    attr_reader :reddit_id, :name, :url, :description, :subscriber_count,
                :icon, :category, :active_users, :nsfw

    def initialize(args = {})
      @reddit_id = args.fetch("id", nil)
      @name = args.fetch("display_name", nil)
      @url = args.fetch("url", nil)
      @description = args.fetch("public_description", nil)
      @subscriber_count = args.fetch("subscribers", nil)
      @icon = args.fetch("header_img", nil)
      @category = args.fetch("advertiser_category", nil)
      @active_users = args.fetch("accounts_active", nil)
      @nsfw = args.fetch("over18", nil)
    end

    def to_h
      {
        reddit_id: reddit_id,
        name: name,
        url: url,
        description: description,
        subscriber_count: subscriber_count,
        icon: icon,
        category: category,
        active_users: active_users,
        nsfw: nsfw
      }
    end

  end
end
