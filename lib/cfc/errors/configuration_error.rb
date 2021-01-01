module CFC
  module Errors
    class ConfigurationError < StandardError
      def initialize(message)
        super(message)
      end
    end
  end
end