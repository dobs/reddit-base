require 'hashie'

module Reddit
  module Base
    # Client that does everything BasicClient does but also attempts to
    # coerce and parse JSON.
    class Client < BasicClient
      def initialize(options)
        super(options)

        connection.builder.insert_before FaradayMiddleware::FollowRedirects, FaradayMiddleware::ParseJson
        connection.builder.insert_before FaradayMiddleware::Reddit::Modhash, Faraday::ManualCache, expires_in: 30
        connection.builder.insert_before Faraday::ManualCache, FaradayMiddleware::Reddit::ForceJson
      end

      def get(url, **options)
        nocache = options.delete(:nocache, false)

        response = connection.get do |req|
          req.url url
          req.headers['x-faraday-manual-cache'] = 'NOCACHE' if nocache
          req.body = options
        end

        Mash.new response.body
      end

      def post(url, **options)
        nocache = options.delete(:nocache, false)

        response = connection.post(url, **options)
        Mash.new response.body
      end
    end
  end
end
