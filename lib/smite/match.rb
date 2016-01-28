module Smite
  class Match < Smite::Object
    def initialize(data)
      @data = DataTransform.transform(data)
    end

    def inspect
      "#<Smite::Match '#{queue}' '#{win_status}'>"
    end
  end
end