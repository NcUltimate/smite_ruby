module Smite
  class Friend < Smite::Object
    def to_player
      Smite::Game.player(name)
    end

    def inspect
      "#<Smite::Friend '#{name}'>"
    end
  end
end