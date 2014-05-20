module Reddit
  module Base
    # Basic client that doesn't make assumptions regarding response type.
    #
    # The reddit API isn't always consistent with its response types so may
    # return HTML even when JSON is requested. Error pages are a common and
    # unavoidable example.
    class BasicClient
      extend Forwardable

      DEFAULT_URL        = 'http://www.reddit.com'.freeze
      DEFAULT_URL_SECURE = 'https://ssl.reddit.com'.freeze

      DEFAULT_OPTIONS = {
        headers: {'User-Agent' => "reddit-base, a reddit client for ruby by /u/dobs (v#{VERSION})"},
        rem: true,
        retries: 3,
        secure: false
      }.freeze

      attr_reader :connection, :options

      def_delegators :connection, :get, :post, :params, :headers

      def build_connection(options)
        @options = DEFAULT_OPTIONS.merge(options)

        @headers = @options.delete(:headers)
        @retries = @options.delete(:retries)
        @secure  = @options.delete(:secure)

        @url = @options[:url] || (@secure ? DEFAULT_URL_SECURE : DEFAULT_URL)

        @connection = Faraday.new(url: @url, headers: @headers) do |builder|
          builder.request  :multipart
          builder.request  :url_encoded
          builder.request  :reddit_authentication, @options
          builder.request  :retry, max: @retries, interval: 2, exceptions: FaradayMiddleware::Reddit::RETRIABLE_ERRORS
          builder.response :follow_redirects
          builder.response :reddit_raise_error
          builder.use      :reddit_rate_limit
          builder.use      :reddit_modhash
          builder.adapter  Faraday.default_adapter
        end
      end

      def initialize(options)
        build_connection(options)
      end
    end
  end
end