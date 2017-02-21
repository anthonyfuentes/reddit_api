
module RedditApi
  class Query

    attr_reader :count, :endpoint, :offset_id, :resource_type

    def initialize(args = {})
      @count = args.fetch(:count)
      @endpoint = args.fetch(:endpoint, "")
      @offset_id = args.fetch(:offset, "")
      @records = args.fetch(:records, {})
      @resource_type = args.fetch(:resource, "")
    end

    def add_records(new_records)
      if count > 1
        add_multiple_records(new_records)
      else
        add_single_record(new_records)
      end
    end

    def collected_records
      records.keys
    end

    def capture_count
      records.length
    end

    protected
    attr_writer :offset_id
    private
    attr_reader :records

    def add_multiple_records(new_records)
      new_records.each do |record|
        add_single_record(record)
        break if records.length == count
      end
    end

    def add_single_record(record)
      records[record] = true
      update_offset_id(record)
    end

    def update_offset_id(record)
      self.offset_id = record["data"]["id"]
    end

  end
end
