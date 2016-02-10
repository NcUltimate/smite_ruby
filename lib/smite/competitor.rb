module Smite
  class Competitor < Smite::Object
    def initialize(data)
      data['Queue'] = data['name']
      super
      @data = DataTransform.transform_items(@data)
      @data = DataTransform.transform_match_achievements(@data)
      @data = DataTransform.transform_match_summary(@data)
    end

    def to_player
      Smite::Game.player(player_id)
    end

    def partied?
      party_id != 0
    end
    
    def winner?
      win_status == 'Winner'
    end

    def loser?
      !winner?
    end

    def inspect
      "#<Smite::Competitor '#{match}' '#{player_name}'>"
    end
  end
end