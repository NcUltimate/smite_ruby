module Smite
  class God < Smite::Object
    def initialize(data)
      @data = DataTransform.transform_abilities(data)
    end

    def inspect
      "#<Smite::God '#{name}'>"
    end
  end
end