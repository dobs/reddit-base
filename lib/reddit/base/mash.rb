module Reddit
  module Base
    class Mash < Hashie::Mash
      include Hashie::Extensions::DeepFetch

      def method_missing(method, *args, &block)
        if self['data'] && self['data'].has_key?(method)
          self['data'].send(method, *args, &block)
        else
          super
        end
      end

      def respond_to?(method)
        (self.respond_to?(:data) && self.data.respond_to?(method)) || super
      end
    end
  end
end