require_relative 'object'
require_relative 'user'
require_relative 'account'
require_relative 'record'

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

    def purge_all_files
      @api.post_to_json("zones/#{id}/purge_cache", { purge_everything: true })
    end

    def records
      data = @api.get_json("zones/#{id}/dns_records")['result']
      data.map { |r| Cloudflare::Record.new(r) }
    end
  end
end
