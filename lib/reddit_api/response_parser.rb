
module RedditApi
  module ResponseParser
    class << self

      ERROR_CODES = (400..511)

      def parse_response(response, count)
        if bad_response?(response)
          handle_bad_response(count)
        else
          handle_successful_response(response, count)
        end
      end

      private

      def bad_response?(response)
        ERROR_CODES.cover?(response.code) || response["error"]
      end

      def handle_bad_response(count)
        if count > 1
          []
        else
          {}
        end
      end

      def handle_successful_response(response, count)
        if count > 1
          handle_plural_response(response)
        else
          handle_singular_response(response)
        end
      end

      def handle_plural_response(response)
        response["data"]["children"]
      end

      def handle_singular_response(response)
        response["data"]
      end

    end
  end
end
