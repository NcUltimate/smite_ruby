module Smite
  class Item < Smite::Object

    def initialize(data)
      super(data)
      effects              = @data.delete('item_description')
      @data['passive']     = effects['SecondaryDescription']
      @data['description'] = effects['Description']
      @data['effects']     = effects['Menuitems'].map do |eff|
        ItemEffect.new(device_name, eff)
      end
    end

    def active?
      type == 'Active'
    end
    alias_method :relic?, :active?

    def consumable?
      type == 'Consumable'
    end

    def item?
      type == 'Item'
    end

    def starter?
      starting_item
    end

    def passive?
      !passive.empty?
    end

    def aura?
      !!(passive =~ /AURA/)
    end

    def cost
      return @cost unless @cost.nil?
      @cost     = price
      child_id  = child_item_id
      until child_id == 0
        child = Smite::Game.item(child_id)
        @cost += child.price
        child_id = child.child_item_id
      end
      @cost
    end

    def tier
      item_tier
    end

    def name
      device_name
    end

    def physical?
      return @physical unless @physical.nil?

      @physical = !(passive.downcase =~ /magic(al)? (pow|pen|lif|dam)/)
      @physical &&= !effects.map(&:attribute).any? do |eff|
        eff =~ /magic(al)?_(pow|pen|lif|dam)/
      end
      @physical
    end

    def magic?
      return @magic unless @magic.nil?

      @magic = !(passive.downcase =~ /physical (pow|pen|lif|dam)/)
      @magic &&= !effects.map(&:attribute).any? do |eff|
        eff =~ /physical_(pow|pen|lif|dam)/
      end
      @magic
    end

    def inspect
      "#<Smite::Item #{item_id} '#{device_name}'>"
    end
  end
end