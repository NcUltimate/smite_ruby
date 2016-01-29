module Smite
  class Item < Smite::Object

    def initialize(data)
      super
      effects              = @data.delete('item_description')
      @data['description'] = effects.delete('Description')
      @data['effects']     = effects['Menuitems'].map { |eff| ItemEffect.new(device_name, eff)}
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
      @physical ||= effects.map(&:attribute).any? { |eff| eff =~ /physical_(power|pen)/ }
    end

    def magic?
      !physical?
    end

    def inspect
      "#<Smite::Item #{item_id} '#{device_name}'>"
    end
  end
end