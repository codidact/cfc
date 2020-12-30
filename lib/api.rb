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

    def get(path, params: nil, headers: nil, cache: true, expiry: nil)
      request(Net::HTTP::Get, build_uri(path, params), headers: headers, cache: cache, expiry: expiry)
    end

    def get_json(path, params: nil, headers: nil, cache: true, expiry: nil)
      request_json(Net::HTTP::Get, build_uri(path, params), headers: headers, cache: cache, expiry: expiry)
    end

    [:post, :put, :patch].each do |method|
      define_method method do |path, data, headers: nil, cache: false, expiry: nil|
        request("Net::HTTP::#{method.capitalize}".constantize, URI("#{@base}#{path}"), data: data, headers: headers, cache: cache, expiry: expiry)
      end

      define_method "#{method}_to_json" do |path, data, headers: nil, cache: false, expiry: nil|
        request_json(Object.const_get("Net::HTTP::#{method.capitalize}"), URI("#{@base}#{path}"), data: data, headers: headers, cache: cache,
                     expiry: expiry)
      end
    end

    protected

    def request(cls, uri, data: nil, headers: nil, cache: true, expiry: nil)
      final_headers = (headers || {}).merge({
        'Authorization' => "Bearer #{@token}",
        'Content-Type' => 'application/json'
      })

      rq = cls.new(uri, final_headers)
      unless data.nil? || rq.is_a?(Net::HTTP::Head)
        rq.body = JSON.dump(data)
      end

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        if cache
          @cache.fetch(Digest::SHA256.hexdigest("#{uri}|#{JSON.dump(final_headers)}"), expiry: expiry) do
            http.request(rq)
          end
        else
          http.request(rq)
        end
      end

      if response.is_a?(Net::HTTPSuccess)
        response
      else
        raise Cloudflare::Errors::HTTPError.new(rq, response)
      end
    end

    def request_json(cls, path, data: nil, headers: nil, cache: true, expiry: nil)
      JSON.parse(request(cls, path, data: data, headers: headers, cache: cache, expiry: expiry).body)
    end

    def build_uri(path, params)
      uri = URI("#{@base}#{path}")
      uri.query = URI.encode_www_form((params || {}).to_a)
      uri
    end
  end
end
