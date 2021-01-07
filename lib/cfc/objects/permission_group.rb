require 'json'
require_relative 'object'

module CFC
  class PermissionGroup < CFC::APIObject
    @api = CFC::API.new

    def self.list
      @api.get_json('user/tokens/permission_groups')['result'].map { |pg| new(pg) }
    end

    def to_json(*_args)
      JSON.dump({ id: id, name: name })
    end
  end
end
