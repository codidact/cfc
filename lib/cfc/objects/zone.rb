require 'json'
require_relative 'object'
require_relative 'user'
require_relative 'account'
require_relative 'record'

module CFC
  class Zone < CFC::APIObject
    relationship :owner, CFC::User
    relationship :account, CFC::Account

    @api = CFC::API.new

    def self.list
      data = @api.get_json('zones')['result']
      data.map { |z| new(z) }
    end

    def purge_all_files
      @api.post_to_json("zones/#{id}/purge_cache", { purge_everything: true })
    end

    def records
      data = @api.get_json("zones/#{id}/dns_records")['result']
      data.map { |r| CFC::Record.new(r) }
    end

    def to_json(*_args)
      "com.cloudflare.api.account.zone.#{id}"
    end
  end
end
