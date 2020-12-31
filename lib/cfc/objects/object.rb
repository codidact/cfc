require_relative '../errors/missing_property'
require_relative '../api'

module CFC
  class APIObject
    @relationships = []

    def self.relationships
      @relationships
    end

    def initialize(data)
      @data = data
      @api = CFC::API.new
      initialize_relationships
    end

    def method_missing(name)
      if @data.include?(name.to_s)
        @data[name.to_s]
      else
        raise CFC::Errors::MissingProperty,
              CFC::Errors::MissingProperty.default_message(self, name)
      end
    end
    
    def respond_to_missing?(name, *_args, **_opts)
      @data.include?(name.to_s)
    end

    def inspect
      "#<#{self.class.name}:0x#{(object_id << 1).to_s(16)} #{@data.map { |k, v| "#{k}=#{v.inspect}" }.join(', ')}>"
    end

    alias_method :to_s, :inspect

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