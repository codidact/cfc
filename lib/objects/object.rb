require_relative '../errors/missing_property'
require_relative '../api'

module Cloudflare
  class APIObject
    @relationships = []

    def self.relationships
      @relationships
    end

    def initialize(data)
      @data = data
      @api = Cloudflare::API.new
      initialize_relationships
    end

    def method_missing(name)
      if @data.include?(name.to_s)
        @data[name.to_s]
      else
        raise Cloudflare::Errors::MissingProperty,
              Cloudflare::Errors::MissingProperty.default_message(name)
      end
    end
    
    def respond_to_missing?(name)
      @data.include?(name.to_s)
    end

    protected

    def self.relationship(property, cls)
      unless defined?(@relationships)
        @relationships = []
      end
      @relationships << [property, cls]
    end

    private

    def initialize_relationships
      (self.class.relationships || []).each do |rel|
        property, cls = rel
        @data[property.to_s] = cls.new(@data[property.to_s])
      end
    end
  end
end