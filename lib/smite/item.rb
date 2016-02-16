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

    def self.physical_item_trees
      [7573, 7827, 7922, 8268, 9624, 9812, 9825, 9830, 9833, 10190, 10662, 11468, 12667, 12671]
    end

    def self.magical_item_trees
      [7610, 8247, 9631, 9847, 9849, 9855, 9858, 9860, 10603, 11123]
    end

    def item_tree_root
      return @root unless @root.nil?
      @root     = self
      child_id  = @root.child_item_id

      until child_id == 0
        @root     = Smite::Game.item(child_id)
        child_id  = @root.child_item_id
      end
      @root
    end

    def active?
      type == 'Active' || type == 'Relic'
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
      @physical ||= !Smite::Item.magical_item_trees.include?(item_tree_root.item_id)
    end

    def magic?
      @magic ||= !Smite::Item.physical_item_trees.include?(item_tree_root.item_id)
    end
    alias_method :magical?, :magic?

    def inspect
      "#<Smite::Item #{item_id} '#{device_name}'>"
    end
  end
end