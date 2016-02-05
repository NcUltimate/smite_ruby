module Smite
  class ItemEffect < Smite::Object
    attr_reader :device_name

    def initialize(item, data)
      @device_name = item
      super(DataTransform.transform_item_effect(data))
    end

    def percentage?
      !percentage.nil?
    end

    def inspect
      "#<Smite::ItemEffect '#{device_name}' #{attribute} +#{amount}#{percentage}>"
    end
  end
end