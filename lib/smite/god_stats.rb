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
      GodStats.new(name, @data, { level: level + 1, items: new_items })
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

    def method_missing(method)
      if data.member?(method.to_s) && !(method.to_s =~ /level/)
        value_for(method)
      else
        super
      end
    end

    private

    def value_for(attribute)
      from_items = bonus_from_items[attribute.to_sym]
      base       = data[attribute.to_s]
      scaling    = send("#{attribute}_per_level".to_sym) * level.to_f

      (from_items + base + scaling).round(2)
    end

    def default_bonus
      @default_bonus ||= attributes.each_with_object({}) { |attr, hash| hash[attr.to_sym] = 0 }
    end

    def movement_speed_per_level
      0
    end
  end
end