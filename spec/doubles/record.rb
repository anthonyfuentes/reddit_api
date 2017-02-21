
class RecordStub

  DEFAULT_ID = 0

  def initialize(args = {})
    @data = args.fetch(:data, default_data(args))
  end

  def [](key)
    self.send(key)
  end

  def id
    data["id"]
  end

  private
  attr_reader :data

  def default_data(args)
    id = args.fetch(:id, DEFAULT_ID)
    { "id" => id }
  end

end
