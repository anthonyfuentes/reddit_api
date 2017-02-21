require File.expand_path("../record", __FILE__)

class ResponseStub

  DEFAULT_TOKEN = "token"
  DEFAULT_CODE = 200
  DEFAULT_DATA = { "children" => [RecordStub.new] }
  DEFAULT_ERROR = nil

  def initialize(args = {})
    @access_token = args.fetch(:token, DEFAULT_TOKEN)
    @code = args.fetch(:code, DEFAULT_CODE)
    @data = args.fetch(:data, DEFAULT_DATA)
    @error = args.fetch(:error, DEFAULT_ERROR)
  end

  def code
  end

  def [](key)
    self.send(key)
  end

  private
  attr_reader :access_token, :data, :error

end
