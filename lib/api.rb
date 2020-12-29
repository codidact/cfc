require 'net/http'
require 'json'
require 'digest'
require 'yaml'
require_relative 'cache'
require_relative 'errors/http_error.rb'

module Cloudflare
  class API
    def initialize
      @config = YAML.load_file(File.join(File.dirname(__FILE__), 'config.yml'))
      @base = 'https://api.cloudflare.com/client/v4/'
      @token = @config['token']
      @cache = Cloudflare::Cache.new
    end

    def get(path, headers: nil, cache: true, expiry: nil)
      request(Net::HTTP::Get, path, headers: headers, cache: cache, expiry: expiry)
    end

    def get_json(path, headers: nil, cache: true, expiry: nil)
      request_json(Net::HTTP::Get, path, headers: headers, cache: cache, expiry: expiry)
    end

    def post(path, data, headers: nil, cache: false, expiry: nil)
      request(Net::HTTP::Post, data: data, headers: headers, cache: cache, expiry: expiry)
    end

    def post_to_json(path, data, headers: nil, cache: false, expiry: nil)
      request_json(Net::HTTP::Post, data: data, headers: headers, cache: cache, expiry: expiry)
    end

    protected

    def request(cls, path, data: nil, headers: nil, cache: true, expiry: nil)
      final_headers = (headers || {}).merge({
        'Authorization' => "Bearer #{@token}",
        'Content-Type' => 'application/json'
      })
      uri = URI("#{@base}#{path}")
      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        request = cls.new(uri, final_headers)
        unless data.nil? || request.is_a?(Net::HTTP::Head)
          request.body = JSON.dump(data)
        end

        if cache
          @cache.fetch(Digest::SHA256.hexdigest("#{uri}|#{JSON.dump(final_headers)}"), expiry: expiry) do
            http.request(request)
          end
        else
          http.request(request)
        end
      end

      if response.is_a?(Net::HTTPSuccess)
        response
      else
        raise Cloudflare::Errors::HTTPError.new(request, response)
      end
    end

    def request_json(cls, path, data: nil, headers: nil, cache: true, expiry: nil)
      JSON.parse(request(cls, path, data: data, headers: headers, cache: cache, expiry: expiry).body)
    end
  end
end
