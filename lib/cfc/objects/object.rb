require_relative '../errors/missing_property'
require_relative '../api'

module CFC
  class APIObject
    @relationships = []

    class << self
      attr_reader :relationships
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

    alias to_s inspect

    def self.relationship(property, cls, multiple: false)
      unless defined?(@relationships)
        @relationships = []
      end
      @relationships << [property, cls, { multiple: multiple }]
    end

    def self.opts(bind)
      bind.local_variables.map do |var|
        [var, bind.local_variable_get(var)]
      end.to_h
    end

    private

    def initialize_relationships
      (self.class.relationships || []).each do |rel|
        property, cls, opts = rel
        @data[property.to_s] = if opts[:multiple]
                                 @data[property.to_s].map { |o| cls.new(o) }
                               else
                                 cls.new(@data[property.to_s])
                               end
      end
    end
  end
end
