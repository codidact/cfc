require_relative 'object'
require_relative 'permission_group'

module CFC
  class APITokenPolicy < CFC::APIObject
    relationship :permission_groups, CFC::PermissionGroup, multiple: true
  end
end
