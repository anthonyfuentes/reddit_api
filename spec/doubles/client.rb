require File.expand_path("../response", __FILE__)

class ExternalClientStub

  DEFAULT_RESPONSE = ResponseStub.new

  attr_reader :response

  def initialize(args = {})
    @response = args.fetch(:response, DEFAULT_RESPONSE)
  end

  def post(url, options)
    response
  end

end
