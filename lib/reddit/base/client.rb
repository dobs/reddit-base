require 'hashie'

module Reddit
  module Base
    # Client that does everything BasicClient does but also attempts to
    # coerce and parse JSON.
    class Client < BasicClient
      def initialize(options)
        super(options)

        connection.builder.insert_before FaradayMiddleware::FollowRedirects, FaradayMiddleware::ParseJson
        connection.builder.insert_before FaradayMiddleware::Reddit::RateLimit, FaradayMiddleware::Reddit::ForceJson
      end

      def get(*args, **options)
        body = connection.get(*args, **options).body
        Mash.new body
      end

      def post(*args, **options)
        body = connection.post(*args, **options).body
        Mash.new body
      end
    end
  end
end
