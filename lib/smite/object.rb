module Smite
  class Object
    attr_reader :data

    def initialize(data)
      @data = data.each_with_object({}) do |(k, v), obj|
        obj[ActiveSupport::Inflector.underscore(k)] = v
      end
    end

    def attributes
      @data.keys
    end

    def method_missing(method)
      camel_method = ActiveSupport::Inflector.underscore(method.to_s)
      @data[camel_method] || super
    end
  end
end