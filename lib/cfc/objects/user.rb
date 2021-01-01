require_relative 'object'

module CFC
  class User < CFC::APIObject
    @api = CFC::API.new

    # Get full details of the current user.
    def self.details
      new(@api.get_json('user')['result'])
    end

    # Update part of the current user's details as permitted.
    #
    # @param first_name [String]
    # @param last_name [String]
    # @param telephone [String]
    # @param country [String]
    # @param zipcode [String]
    def self.edit(first_name: nil, last_name: nil, telephone: nil, country: nil, zipcode: nil)
      data = opts(binding)
      @api.patch_to_json('user', data)
    end
  end
end
