module Smite
  class Match < Smite::Object
    def initialize(data)
      super
      @data = DataTransform.transform_gods(@data)
      @data = DataTransform.transform_items(@data)
      @data = DataTransform.transform_match(@data)
    end

    def inspect
      "#<Smite::Match '#{queue}' '#{win_status}'>"
    end
  end
end