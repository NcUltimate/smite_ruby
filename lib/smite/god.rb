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
      !!(type =~ /Ranged/i) || !!(name =~ /Sylvanus/i)
    end

    def melee?
      !ranged?
    end

    def physical?
      !!(type =~ /Physical/i) || !!(role =~ /Hunter|Warrior|Assassin/i)
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

    def hindu?
      !!(pantheon =~ /Hindu/)
    end

    def mayan?
      !!(pantheon =~ /Mayan/)
    end

    def greek?
      !!(pantheon =~ /Greek/)
    end

    def roman?
      !!(pantheon =~ /Roman/)
    end

    def egyptian?
      !!(pantheon =~ /Egyptian/)
    end

    def japanese?
      !!(pantheon =~ /Japanese/)
    end

    def norse?
      !!(pantheon =~ /Norse/)
    end

    def chinese?
      !!(pantheon =~ /Chinese/)
    end

    def short_lore
      lore.split('.')[0..2].join('.') + '.'
    end

    def inspect
      "#<Smite::God #{id} '#{name}'>"
    end
  end
end