module Cloudflare
  module Errors
    class MissingProperty < StandardError
      def self.default_message(property)
        "This #{name} does not have a `#{property}' property. If you are accessing this object from a relationship on " \
        "another object, the property may not have been fetched."
      end

      def initialize(message)
        super
      end
    end
  end
end
