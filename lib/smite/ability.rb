module Smite
  class Ability < Smite::Object
    def which
      case number
      when 1 then '1st Ability'
      when 2 then '2nd Ability'
      when 3 then '3rd Ability'
      when 4 then 'Ultimate'
      when 5 then 'Passive'
      end
    end

    def number
      ability_number
    end

    def name
      summary
    end

    def inspect
      "#<Smite::Ability '#{summary}'>"
    end
  end
end