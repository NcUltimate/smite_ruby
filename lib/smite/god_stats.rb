module Smite
  class GodStats < Smite::Object
    attr_reader :name, :level, :items, :stacks
    
    def initialize(god_name, data, params = { level: 0 })
      super(data)
      @name = god_name

      # make sure ratatoskr only has 1 acorn and items are unique
      @items  = (params[:items] || []).uniq do |a|
        a.name =~ /acorn/i ? 'acorn' : a.name
      end

      # make sure only 6 items total
      @items = @items[0..5]

      # make sure ratatoskr has at least 1 acorn
      if god_name.downcase == 'ratatoskr'
        if !@items.any? { |i| i.name =~ /acorn/i }
          @items[0] = Smite::Game.item('magic acorn')
        end
      end

      # make sure level is between 0 and 20 (0 for base stats)
      @level  = [[params[:level].to_i, 20].min, 0].max
      @stacks = params[:stacks] || {}
    end

    def at_level(new_level)
      GodStats.new(name, @data, { level: new_level, items: items, stacks: stacks })
    end

    def with_items(new_items, stacks = @stacks)
      stacks.delete_if { |k,v| v.nil? }
      GodStats.new(name, @data, { level: level, items: new_items, stacks: stacks })
    end

    def bonus_from_items
      return @item_bonus unless @item_bonus.nil?

      @item_bonus = {}
      @item_bonus[:flat] = default_bonus.dup
      @item_bonus[:perc] = default_bonus.dup

      # only accept physical items for physical gods and vice versa
      physical  = Smite::Game.god(@name).physical?
      @items    = @items.select do |item|
        physical ? item.physical? : item.magic?
      end
      return @item_bonus if items.empty?

      bonus_from_active_item_effects
      bonus_from_passive_item_effects

      @item_bonus
    end

    def magical_protection
      magic_protection
    end

    def magic_power
      magical_power
    end

    def attack_speed
      [value_for(:attack_speed), 2.5].min
    end

    def movement_speed
      raw_speed = value_for(:movement_speed)

      ret = if raw_speed <= 457
        raw_speed
      elsif raw_speed <= 540.5
        dr = raw_speed - 457
        457 + 0.8 * dr
      else
        dr = raw_speed - 540.5
        457 + (540.5 - 457) * 0.8 + dr * 0.5
      end
      ret.round
    end

    def summary
      attributes.each_with_object({}) do |attr, hash|
        hash[attr.to_sym] = send(attr.to_sym)
      end
    end

    def inspect
      "#<Smite::GodStats '#{name}' Level #{level}>"
    end

    def method_missing(method)
      if data.member?(method.to_s) && !(method.to_s =~ /level/)
        value_for(method)
      else
        super
      end
    end

    private

    def value_for(attribute)
      scaling         = send("#{attribute}_per_level".to_sym) * level.to_f
      flat_from_items = bonus_from_items[:flat][attribute.to_sym]
      perc_from_items = bonus_from_items[:perc][attribute.to_sym]

      passive     = from_god_passive(attribute) + from_item_passive(attribute)
      base        = data[attribute.to_s]
    
      flat_amount = (flat_from_items + base + scaling + passive)

      ret = (flat_amount * (perc_from_items + 1)).round(2)
      attribute =~ /5|attack/ ? ret : ret.round
    end

    def bonus_from_active_item_effects
      # Active effects first
      items.map(&:active_effects).flatten.select do |effect|
        next unless attributes.include?(effect.attribute)

        if effect.percentage?
          @item_bonus[:perc][effect.attribute.to_sym] += effect.amount/100.0
        else
          @item_bonus[:flat][effect.attribute.to_sym] += effect.amount
        end
      end
    end

    def bonus_from_passive_item_effects
      # passive (potentially stacking) effects second
      items.select do |item|
        item.passive_effects.each do |effect|
          next unless attributes.include?(effect.attribute)

          base_stacks = item.stacking? ? 0 : 1
          multiplier =  if @stacks.empty? || @stacks[item.name.downcase].nil?
            base_stacks
          else
            [ [@stacks[item.name.downcase], base_stacks].max , item.max_stacks ].min.to_i
          end

          if effect.percentage?
            @item_bonus[:perc][effect.attribute.to_sym] += multiplier * effect.amount/100.0
          else
            @item_bonus[:flat][effect.attribute.to_sym] += multiplier * effect.amount
          end
        end
      end
    end

    def from_god_passive(attribute)
      return 0 unless attribute.to_s =~ /power/

      if attribute == :physical_power
        case name
        when 'Mercury'
          (movement_speed - 375) * 0.25
        when 'Vamana'
          physical_protection * 0.20
        else
          0
        end
      else
        case name
        when 'Scylla'
          case level
          when 0..7   then 0
          when 8..12  then 20
          when 13..16 then 40
          when 17..18 then 60
          when 19     then 80
          end
        when 'Ares'
          30 * items.count(&:aura?)
        when 'Kukulkan'
          mana * 0.05
        else
          0
        end
      end
    end

    def from_item_passive(attribute)
      case attribute.to_s
      when /magical_power/i
        if items.any? { |i| i.name =~ /Book of Thoth/i }
          mana * 0.03
        else
          0
        end
      when /physical_power/i
        if items.any? { |i| i.name =~ /Transcendence/i }
          mana * 0.03
        else
          0
        end
      else
        0
      end
    end

    def default_bonus
      @default_bonus ||= attributes.each_with_object({}) { |attr, hash| hash[attr.to_sym] = 0 }
    end

    def movement_speed_per_level
      0
    end

    def magical_power_per_level
      0
    end

    def physical_power_per_level
      0
    end
  end
end