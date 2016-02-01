module Smite
  class RecentMatch < Smite::Object
    def initialize(data)
      super
      @data = DataTransform.transform_gods(@data)
      @data = DataTransform.transform_items(@data)
      @data = DataTransform.transform_recent_match(@data)
    end

    def id
      match
    end

    def inspect
      "#<Smite::RecentMatch #{match} '#{queue}' (#{win_status})>"
    end
  end
end