require_relative 'object'
require_relative 'permission_group'

module CFC
  class APITokenPolicy < CFC::APIObject
    relationship :permission_groups, CFC::PermissionGroup, multiple: true

    def initialize(data)
      super(data)
    end
  end
end