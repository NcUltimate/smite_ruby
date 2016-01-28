module Smite
  class DataTransform

    def self.transform(data)
      new_data = data.dup
      new_data = transform_items(new_data)
      new_data = transform_gods(new_data)
      new_data = transform_abilities(new_data)
      transform_match(new_data)
    end

    def self.transform_items(data)
      item_fields = data.slice(*item_map_fields)
      return data if item_fields.empty?

      data['items'] = item_fields.values.map { |id| Smite::Game.item(id.to_i) }
      data.except(*item_filter_fields)
    end

    def self.transform_gods(data)
      god_fields = data.slice(*god_map_fields)
      return data if god_fields.empty?

      data['god'] = god_fields.values.map { |id| Smite::Game.god(id.to_i) }[0]
      data.except(*god_filter_fields)
    end

    def self.transform_abilities(data)
      ability_fields = data.slice(*ability_map_fields)
      return data if ability_fields.empty?

      data['abilities'] = ability_fields.values.map do |ability_data|
        data_attrs = ability_data.slice('Id', 'Summary', 'URL')
        desc       = ability_data['Description']['itemDescription']

        Ability.new(data_attrs.merge(desc))
      end

      data.except(*ability_filter_fields)
    end

    def self.transform_match(data)
      return data unless data['Queue']

      if data['Queue'] =~ /League/
        data
      else
        data.except(*match_filter_fields)
      end
    end

    def self.item_map_fields
      %w( ActiveId1 ActiveId2 ItemId1 ItemId2 ItemId3 ItemId4 ItemId5 ItemId6 )
    end

    def self.item_filter_fields
      item_map_fields + %w(
        Item_1 Item_2 Item_3 Item_4 Item_5 Item_6 Active_1 Active_2 Active_3
      )
    end

    def self.ability_map_fields
      %w( Ability_1 Ability_2 Ability_3 Ability_4 Ability_5 )
    end

    def self.ability_filter_fields
      ability_map_fields + %w(
        Ability1 Ability2 Ability3 Ability4 Ability5
        AbilityId1 AbilityId2 AbilityId3 AbilityId4 AbilityId5
        abilityDescription1 abilityDescription2
        abilityDescription3 abilityDescription4
        abilityDescription5
      )
    end

    def self.match_filter_fields
      %w(
        Ban1 Ban2 Ban3 Ban4 Ban5 Ban6
        Ban1Id Ban2Id Ban3Id Ban4Id Ban5Id Ban6Id
      )
    end

    def self.god_map_fields
      %w(GodId god_id)
    end

    def self.god_filter_fields
      god_map_fields + %w(God)
    end
  end
end