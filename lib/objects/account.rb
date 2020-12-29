require_relative 'object'

module Cloudflare
  class Account < Cloudflare::APIObject
    def initialize(data)
      super(data)
    end
  end
end
