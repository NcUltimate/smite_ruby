module Smite
  class GodRank < Smite::Object
    def initialize(data)
      super(DataTransform.transform_gods(data))
    end

    def level
      case rank
      when 0      then  'none'
      when (1..4) then  'gold'
      when (5..9) then  'legendary'
      when 10     then  'diamond'
      end
    end

    def mastery
      mastered ? 'mastered' : 'unmastered'
    end

    def mastered?
      rank > 0
    end

    def inspect
      "#<Smite::GodRank '#{god.name}' Lvl. #{rank} (#{level})>"
    end
  end
end