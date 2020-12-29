require_relative 'object'
require_relative 'user'
require_relative 'account'

module Cloudflare
  class Zone < Cloudflare::APIObject
    relationship :owner, Cloudflare::User
    relationship :account, Cloudflare::Account

    @api = Cloudflare::API.new

    def self.list
      data = @api.get_json('zones')['result']
      data.map { |z| new(z) }
    end

    def initialize(data)
      super(data)
    end
  end
end
