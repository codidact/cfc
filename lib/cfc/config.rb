require 'singleton'
require_relative 'errors/configuration_error'

module CFC
  class Config
    include Singleton
    attr_accessor :token, :api_key, :api_email

    def self.configure
      yield CFC::Config.instance
      if [token, api_key, api_email].all?(&:nil?)
        raise CFC::Errors::ConfigurationError, 'Either `token` or BOTH of `api_key`, `api_email` must be set on call ' \
                                               "to `configure'."
      elsif token.nil? && [api_key, api_email].any?(&:nil?)
        raise CFC::Errors::ConfigurationError, 'Both `api_key` AND `api_email` must be set when not using token auth.'
      end
    end
  end
end