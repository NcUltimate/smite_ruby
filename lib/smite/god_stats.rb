module Smite
  class GodStats < Smite::Object
    attr_reader :name, :level, :items
    
    def initialize(god_name, data, params = { level: 1 })
      super(data)
      @name   = god_name
      @items  = params[:items] || []
      @level  = [[(params[:level].to_i - 1), 19].min, 0].max
    end

    def at_level(new_level)
      GodStats.new(name, @data, { level: new_level, items: items })
    end

    def with_items(new_items)
      GodStats.new(name, @data, { level: level, items: new_items })
    end

    def movement_speed
      from_items = bonus_from_items[:movement_speed]
      base       = data['movement_speed']
      scaling    = movement_speed_per_level * level

      from_items + base + scaling
    end

    def health
      from_items  = bonus_from_items[:health]
      base        = data['health']
      scaling     = health_per_level * level

      from_items + base + scaling
    end

    def mana
      from_items  = bonus_from_items[:mana]
      base        = data['mana']
      scaling     = mana_per_level * level

      from_items + base + scaling
    end

    def mp5
      from_items  = bonus_from_items[:mp5]
      base        = data['mp5']
      scaling     = (mp5_per_level * level.to_f).to_i
      
      from_items + base + scaling
    end

    def hp5
      from_items  = bonus_from_items[:hp5]
      base        = data['hp5']
      scaling     = (hp5_per_level * level.to_f).to_i
      
      from_items + base + scaling
    end

    def attack_speed
      from_items  = bonus_from_items[:attack_speed]
      base        = data['attack_speed']
      scaling     = (attack_speed_per_level * level.to_f).to_i
      
      from_items + base + scaling
    end

    def magical_power
      from_items  = bonus_from_items[:magical_power]
      base        = data['magical_power']
      scaling     = magical_power_per_level * level
      
      from_items + base + scaling
    end

    def magic_protection
      from_items  = bonus_from_items[:magic_protection]
      base        = data['magic_protection']
      scaling     = (magic_protection_per_level * level.to_f).to_i
      
      from_items + base + scaling
    end

    def physical_power
      from_items  = bonus_from_items[:physical_power]
      base        = data['physical_power']
      scaling     = physical_power_per_level * level
      
      from_items + base + scaling
    end

    def physical_protection
      from_items  = bonus_from_items[:physical_protection]
      base        = data['physical_protection']
      scaling     = (physical_protection_per_level * level.to_f).to_i
      
      from_items + base + scaling
    end

    def bonus_from_items
      return @item_bonus unless @item_bonus.nil?

      @item_bonus = default_bonus
      items.map(&:effects).flatten.select do |effect|
        next unless attributes.include?(effect.attribute)
        @item_bonus[effect.attribute.to_sym] += effect.amount
      end

      @item_bonus
    end

    def summary
      attributes.each_with_object({}) do |attr, hash|
        hash[attr.to_sym] = send(attr.to_sym)
      end
    end

    def inspect
      "#<Smite::GodStats '#{name}' Level #{level + 1}>"
    end

    private

    def default_bonus
      @default_bonus ||= attributes.each_with_object({}) { |attr, hash| hash[attr.to_sym] = 0 }
    end

    def movement_speed_per_level
      0
    end
  end
end