require 'json'
require_relative 'object'
require_relative 'permission_group'

module CFC
  class APITokenPolicy < CFC::APIObject
    relationship :permission_groups, CFC::PermissionGroup, multiple: true

    def self.build(effect:, resources:, permission_groups:)
      new(JSON.parse(JSON.dump({
        effect: effect,
        resources: resources&.map { |k, v| [k.to_json, v] }&.to_h,
        permission_groups: permission_groups
      }.compact)))
    end
  end
end
