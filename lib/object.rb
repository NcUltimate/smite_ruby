module Smite
  class Object
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def attributes
      @data.keys.map(&ActiveSupport::Inflector.method(:underscore))
    end

    def method_missing(method)
      key = @data.keys.find do |attribute|
        camel_attr   = ActiveSupport::Inflector.underscore(attribute)
        camel_method = ActiveSupport::Inflector.underscore(method.to_s)
        camel_attr == camel_method
      end

      key ? @data[key] : super
    end
  end
end