module Reddit
  module Base
    # Basic client that doesn't make assumptions regarding response type.
    #
    # The reddit API isn't always consistent with its response types so may
    # return HTML even when JSON is requested. Error pages are a common and
    # unavoidable example.
    class BasicClient
      extend Forwardable

      DEFAULT_OPTIONS = {
        url: 'http://www.reddit.com',
        headers: {'User-Agent' => "reddit-base, a reddit client for ruby by /u/dobs (v#{VERSION})"}
      }.freeze

      attr_reader :connection, :options

      def_delegators :connection, :get, :post, :params, :headers

      def initialize(options)
        @options = DEFAULT_OPTIONS.merge(options)
        @connection = Faraday.new(url: @options[:url], headers: @options[:headers]) do |builder|
          builder.request :multipart
          builder.request  :url_encoded
          builder.request  :reddit_authentication, @options
          builder.response :follow_redirects
          builder.use  :reddit_rate_limit
          builder.use  :reddit_modhash
          builder.adapter  Faraday.default_adapter
        end
      end
    end
  end
end