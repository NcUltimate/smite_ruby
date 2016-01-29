module Smite
  class DataTransform
    class << self

      def transform_items(data)
        item_fields = data.slice(*item_map_fields)
        return data if item_fields.empty?

        data['items'] = item_fields.values.map { |id| Smite::Game.item(id.to_i) }
        data.except(*item_filter_fields)
      end

      def transform_gods(data)
        god_fields = data.slice(*god_map_fields)
        return data if god_fields.empty?

        data['god'] = god_fields.values.map { |id| Smite::Game.god(id.to_i) }[0]
        data.except(*god_filter_fields)
      end

      def transform_abilities(data)
        ability_fields = data.slice(*ability_map_fields)
        return data if ability_fields.empty?

        data['abilities'] = ability_fields.values.map do |ability_data|
          data_attrs = ability_data.slice('Id', 'Summary', 'URL')
          desc       = ability_data['Description']['itemDescription']

          Ability.new(data_attrs.merge(desc))
        end

        data.except(*ability_filter_fields)
      end

      def transform_match(data)
        return data unless data['Queue']

        if data['Queue'] =~ /League/
          data
        else
          data.except(*match_filter_fields)
        end
      end

      def transform_stats(data)
        stat_fields = data.slice(*stats_map_fields)
        return data if stat_fields.empty?

        stat_fields['movement_speed'] = stat_fields.delete('speed')
        stat_fields['mp5']            = stat_fields.delete('mana_per_five')
        stat_fields['hp5']            = stat_fields.delete('health_per_five')
        data['stats'] = GodStats.new(data['name'], stat_fields)
        data.except(*stats_filter_fields)
      end

      def transform_item_effect(data)
        return unless data['Description'] and data['Value']

        effect = data.delete('Description').tr(' ','')
        effect = ActiveSupport::Inflector.underscore(effect)
        data['attribute'] = effect

        value = data.delete('Value')
        @percentage = value[/%/]
        value = value.tr('+', '').to_i
        data['amount'] = value
        data
      end

      private

      def item_map_fields
        %w(
          active_id1 active_id2 item_id1 item_id2
          item_id3 item_id4 item_id5 item_id6
        )
      end

      def item_filter_fields
        item_map_fields + %w(
          item_1 item_2 item_3 item_4 item_5
          item_6 active_1 active_2 active_3
        )
      end

      def ability_map_fields
        %w( ability_1 ability_2 ability_3 ability_4 ability_5 )
      end

      def ability_filter_fields
        ability_map_fields + %w(
          ability1 ability2 ability3 ability4 ability5
          ability_id1 ability_id2 ability_id3 ability_id4 ability_id5
          ability_description1 ability_description2
          ability_description3 ability_description4
          ability_description5 god_ability1_url god_ability2_url
          god_ability3_url god_ability4_url god_ability5_url
        )
      end

      def match_filter_fields
        %w(
          ban1 ban2 ban3 ban4 ban5 ban6
          ban1_id ban2_id ban3_id
          ban4_id ban5_id ban6_id
        )
      end

      def stats_map_fields
        %w( 
          speed attack_speed attack_speed_per_level
          health health_per_level
          mana mana_per_level
          mana_per_five mp5_per_level
          health_per_five hp5_per_level
          magical_power magical_power_per_level
          physical_power physical_power_per_level
          magic_protection magic_protection_per_level
          physical_protection physical_protection_per_level
        )
      end

      def stats_filter_fields
        stats_map_fields
      end

      def god_map_fields
        %w(god_id)
      end

      def god_filter_fields
        god_map_fields + %w(god)
      end
    end
  end
end