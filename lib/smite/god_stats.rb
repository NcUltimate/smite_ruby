module Smite
  class GodStats < Smite::Object
    attr_reader :name, :item_bonus
    attr_accessor :level, :items
    
    def initialize(god_name, data)
      super(data)
      @name       = god_name
      @items      = []
      @level      = 0
      @item_bonus = default_bonus
    end

    def level=(new_level)
      @level = (new_level.to_i - 1) % 20
    end

    def items=(new_items)
      @items      = new_items
      @item_bonus = default_bonus
    end

    def movement_speed
      from_items = item_bonus[:movement_speed]
      base       = data['movement_speed']

      from_items + base
    end

    def health
      from_items  = item_bonus[:health]
      base        = data['health']
      scaling     = health_per_level * level

      from_items + base + scaling
    end

    def mana
      from_items  = item_bonus[:mana]
      base        = data['mana']
      scaling     = mana_per_level * level

      from_items + base + scaling
    end

    def mp5
      from_items  = item_bonus[:mp5]
      base        = data['mp5']
      scaling     = (mp5_per_level * level.to_f).to_i
      
      from_items + base + scaling
    end

    def hp5
      from_items  = item_bonus[:hp5]
      base        = data['hp5']
      scaling     = (hp5_per_level * level.to_f).to_i
      
      from_items + base + scaling
    end

    def attack_speed
      from_items  = item_bonus[:attack_speed]
      base        = data['attack_speed']
      scaling     = (attack_speed_per_level * level.to_f).to_i
      
      from_items + base + scaling
    end

    def magic_power
      from_items  = item_bonus[:magic_power]
      base        = data['magic_power']
      scaling     = magic_power_per_level * level
      
      from_items + base + scaling
    end

    def magic_protection
      from_items  = item_bonus[:magic_protection]
      base        = data['magic_protection']
      scaling     = (magic_protection_per_level * level.to_f).to_i
      
      from_items + base + scaling
    end

    def physical_protection
      from_items  = item_bonus[:physical_protection]
      base        = data['physical_protection']
      scaling     = (physical_protection_per_level * level.to_f).to_i
      
      from_items + base + scaling
    end

    def item_bonus
      return @item_bonus unless @item_bonus == default_bonus and !items.empty?

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
  end
end