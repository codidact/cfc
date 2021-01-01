require_relative 'object'
require_relative 'api_token_policy'

module CFC
  class UserAPIToken < CFC::APIObject
    relationship :policies, CFC::APITokenPolicy, multiple: true

    @api = CFC::API.new

    def self.list(page:, per_page:, direction:); end
  end
end
