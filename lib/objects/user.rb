require_relative 'object'

module Cloudflare
  class User < Cloudflare::APIObject
    def initialize(data)
      super(data)
    end
  end
end
