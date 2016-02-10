module Smite
  class MatchSummary < Smite::Object
    def initialize(data)
      super
      @data = DataTransform.transform_gods(@data)
      @data = DataTransform.transform_items(@data)
      @data = DataTransform.transform_match_summary(@data)
    end

    def to_full_match
      Smite::Game.match(match)
    end
    alias_method :full_match, :to_full_match

    def win?
      win_status == 'Win'
    end

    def loss?
      !win?
    end

    def id
      match
    end

    def inspect
      "#<Smite::MatchSummary #{match} '#{queue}' (#{win_status})>"
    end
  end
end