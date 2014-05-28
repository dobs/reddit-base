module Reddit
  module Base
    # Client that does everything BasicClient does but also attempts to
    # coerce and parse JSON.
    class Client < BasicClient
      def initialize(options)
        super(options)

        connection.builder.insert_before FaradayMiddleware::FollowRedirects, FaradayMiddleware::ParseJson
        connection.builder.insert_before FaradayMiddleware::ParseJson, FaradayMiddleware::Mashify
        connection.builder.insert_before FaradayMiddleware::Reddit::Modhash, Faraday::ManualCache, expires_in: 30
        connection.builder.insert_before Faraday::ManualCache, FaradayMiddleware::Reddit::ForceJson
      end

      def delete(url, **options)
        nocache = options.delete(:nocache)

        connection.delete(url, **options)
      end

      def get(url, **options)
        nocache = options.delete(:nocache)

        connection.get do |req|
          req.url url
          req.headers['x-faraday-manual-cache'] = 'NOCACHE' if nocache
          req.params = options
        end
      end

      def post(url, **options)
        nocache = options.delete(:nocache)

        connection.post(url, **options)
      end

      def put(url, **options)
        nocache = options.delete(:nocache)

        connection.put(url, **options)
      end
    end
  end
end
