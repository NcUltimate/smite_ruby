module Smite
  class Item < Smite::Object

    def initialize(data)
      super(data)
      effects                 = @data.delete('item_description')
      @data['passive']        = effects['SecondaryDescription']
      @data['description']    = effects['Description']
      @data['active_effects'] = effects['Menuitems'].map do |eff|
        ItemEffect.new(device_name, eff)
      end
    end

    def self.physical_item_trees
      [7573, 7827, 7922, 8268, 9624, 9812, 9825, 9830, 9833, 10190, 10662, 11122, 11468, 12667, 12671]
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

    def stacking?(perma_stacks = false)
      return false unless passive?
      if perma_stacks
        !!(passive =~ /(per|for each).+?kill/i)
      else
        !!(passive =~ /stack/i)
      end
    end

    def max_stacks
      @max_stacks = 1 unless stacking?
      return @max_stacks unless @max_stacks.nil?

      @max_stacks ||= passive.match(/max\.?.+?(\d+)/i)[1].to_i
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

    def effects
      active_effects + passive_effects
    end

    def passive_effects
      @passive_effects = [] unless passive?
      return @passive_effects unless @passive_effects.nil?

      fx    = Smite::Game.item_effects + ['magical_protection', 'lifesteal']
      fx    = fx.map { |e| e.tr('_', ' ') + "s?" }.join('\b|')
      amt   = '(\+?[\.\d]+%?)'

      r1 = /gain #{amt} (#{fx}\b)(?: and #{amt} (#{fx}\b))?/i
      r2 = /increas(?:es?|ing)?(?: your)? (#{fx}\b) by #{amt}(?: and (#{fx}\b) by #{amt})?/i
      r3 = /grant(?:s you|ing)? #{amt} (#{fx}\b) and #{amt} (#{fx}\b)/i
      r4 = /your (#{fx}\b) increases by #{amt}/i

      scanned = [r1,r2,r3,r4].inject([]) { |arr, regex| arr << (passive.scan(regex)[0]||[]).compact }
      scanned = scanned.reject(&:empty?)

      scanned = scanned.map do |e|
        e.each_slice(2).to_a.map do |a|
          a = a.minmax
          a[1] = a[1][-1] == 's' ? a[1][0...-1] : a[1]
          { 'Description' => a[1], 'Value' => a[0] }
        end
      end
      @passive_effects = scanned.flatten.map do |effect_data|
        ItemEffect.new(name, effect_data)
      end
    end
  end
end