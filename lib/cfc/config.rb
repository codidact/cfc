require 'singleton'

module CFC
  class Config
    include Singleton
    attr_accessor :token

    def self.configure
      yield CFC::Config.instance
    end
  end
end