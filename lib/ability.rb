module Smite
  class Ability < Smite::Object
    def inspect
      "#<Smite::Ability '#{summary}'>"
    end
  end
end