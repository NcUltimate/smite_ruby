module Smite
  class Ability < Smite::Object
    def name
      summary
    end

    def inspect
      "#<Smite::Ability '#{summary}'>"
    end
  end
end