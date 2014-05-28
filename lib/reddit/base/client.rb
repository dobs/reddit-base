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

      def delete(url, **options)
        nocache = options.delete(:nocache)

        response = connection.delete(url, **options)
        mashify response
      end

      def get(url, **options)
        nocache = options.delete(:nocache)

        response = connection.get do |req|
          req.url url
          req.headers['x-faraday-manual-cache'] = 'NOCACHE' if nocache
          req.params = options
        end

        mashify response
      end

      def post(url, **options)
        nocache = options.delete(:nocache)

        response = connection.post(url, **options)
        mashify response
      end

      def put(url, **options)
        nocache = options.delete(:nocache)

        response = connection.put(url, **options)
        mashify response
      end

      def mashify(response)
        if response.body.is_a? Array
          response.body.map do |x|
            output = Mash.new x
            output.response = response
            output
          end
        else
          output = Mash.new response.body
          output.response = response
          output
        end
      end
    end
  end
end
