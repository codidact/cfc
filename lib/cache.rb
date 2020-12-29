require 'ostruct'
require 'date'

module Cloudflare
  class Cache
    def initialize
      @cache = {}
    end

    def include?(key)
      @cache.include?(key) && (@cache[key].expiry.nil? || @cache[key].expiry >= DateTime.now.to_time.to_i)
    end

    def [](key)
      valid?(key) ? @cache[key].data : nil
    end

    def []=(key, value)
      @cache[key] = OpenStruct.new(data: value, expiry: nil)
    end

    def write(key, value, expiry: nil)
      @cache[key] = OpenStruct.new(data: value, expiry: expiry)
    end

    def read(key)
      valid?(key) ? @cache[key].data : nil
    end

    def fetch(key, expiry: nil)
      if valid?(key)
        @cache[key].data
      else
        data = block_given? ? yield : nil
        write(key, data, expiry: expiry)
        data
      end
    end

    alias_method :valid?, :include?
  end
end
