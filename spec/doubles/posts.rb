class PostsStub

  DEFAULT_RESPONSE = [
    ::RedditApi::Post.new('author' => 'name'),
    ::RedditApi::Post.new('author' => 'name')
  ]

  attr_reader :response

  def initialize(args = {})
    @response = args.fetch(:response, DEFAULT_RESPONSE)
  end
  
  def top(subreddit, count)
    response
  end
end


