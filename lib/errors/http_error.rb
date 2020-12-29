require 'json'

module Cloudflare
  module Errors
    class HTTPError < StandardError
      attr_reader :request, :response

      def initialize(request, response)
        super "Cloudflare API request returned HTTP #{response.code}"
        @request = request
        @response = response
      end

      def data
        JSON.parse(@response.body)
      end
    end
  end
end
