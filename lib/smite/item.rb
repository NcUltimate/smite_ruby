module Smite
  class Item < Smite::Object

    def initialize(data)
      super(data)
      effects              = @data.delete('item_description')
      @data['description'] = effects.delete('Description')
      @data['effects']     = effects['Menuitems'].map do |eff|
        ItemEffect.new(device_name, eff)
      end
    end

    def active?
      type == 'Active'
    end

    def consumable?
      type == 'Consumable'
    end

    def item?
      type == 'Item'
    end

    def physical?
      @physical ||= !effects.map(&:attribute).any? do |eff|
        eff =~ /magic_(power|pen)/
      end
    end

    def magic?
      @magic ||= !effects.map(&:attribute).any? do |eff|
        eff =~ /physical_(power|pen)/
      end
    end

    def inspect
      "#<Smite::Item #{item_id} '#{device_name}'>"
    end
  end
end