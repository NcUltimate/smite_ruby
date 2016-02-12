module Smite
  class God < Smite::Object
    def initialize(data)
      super
      @data = DataTransform.transform_abilities(@data)
      @data = DataTransform.transform_stats(@data)
    end

    def on_free_rotation?
      !on_free_rotation.empty?
    end

    def ranged?
      !!(type =~ /Ranged/i)
    end

    def melee?
      !ranged?
    end

    def physical?
      !!(type =~ /Physical/i)
    end

    def magic?
      !physical?
    end
    alias_method :magical?, :magic?

    def role
      @role ||= roles.strip
    end

    def mage?
      !!(roles =~ /Mage/)
    end

    def hunter?
      !!(roles =~ /Hunter/)
    end

    def assassin?
      !!(roles =~ /Assassin/)
    end

    def guardian?
      !!(roles =~ /Guardian/)
    end

    def warrior?
      !!(roles =~ /Warrior/)
    end

    def inspect
      "#<Smite::God #{id} '#{name}'>"
    end
  end
end