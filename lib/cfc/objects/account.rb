require_relative 'object'

module CFC
  class Account < CFC::APIObject
    def initialize(data)
      super(data)
    end
  end
end
