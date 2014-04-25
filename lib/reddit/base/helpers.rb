module Reddit
  module Base
    module Helpers
      def self.simplify(json)
        return json unless json.is_a? Hash

        if json['data']
          json['data']['kind'] = json['kind'] if json['data'].is_a? Hash
          json = simplify json['data']
        elsif json['children']
          json['children'] = json['children'].map { |child| simplify child }
        else
          json.keys.each do |key|
            json[key] = simplify json[key]
          end
        end

        json
      end
    end
  end
end