require_relative 'object'

module CFC
  class User < CFC::APIObject
    def initialize(data)
      super(data)
    end
  end
end
