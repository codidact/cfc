require_relative 'object'
require_relative 'api_token_policy'

module CFC
  class UserAPIToken < CFC::APIObject
    relationship :policies, CFC::APITokenPolicy, multiple: true

    @api = CFC::API.new

    def self.list(page: nil, per_page: nil, direction: nil)
      params = opts(binding).compact
      @api.get_json('user/tokens', params: params)['result'].map { |o| new(o) }
    end

    def self.details(identifier)
      new(@api.get_json("user/tokens/#{identifier}")['result'])
    end

    def self.delete(identifier)
      @api.delete_to_json("user/tokens/#{identifier}")
    end

    def self.roll(identifier)
      @api.put_to_json("user/tokens/#{identifier}/value", {})
    end

    def self.create(name:, policies:, not_before: nil, expires_on: nil, condition: nil)
      data = { name: name, policies: policies, not_before: not_before, expires_on: expires_on, condition: condition }
      data = data.compact
      new(@api.post_to_json('user/tokens', data)['result'])
    end

    def details
      CFC::UserAPIToken.details(id)
    end

    def delete
      CFC::UserAPIToken.delete(id)
    end

    def roll
      CFC::UserAPIToken.roll(id)
    end
  end
end
