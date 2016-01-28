module Smite
  class Game
    class << self
      attr_reader :client,:lang_code

      def authenticate!(dev_id, auth_key, lang_code = 1)
        @client     = Smite::Client.new(dev_id, auth_key)
        @lang_code  = lang_code
        self
      end

      def item(name_or_id)
        id_to_item[name_or_id] ||
          id_to_item[name_to_itemid[name_or_id]]
      end

      def god(name_or_id)
        id_to_god[name_or_id] ||
          id_to_god[name_to_godid[name_or_id]]
      end

      def match(match_id)
        Match.new(match_details(match_id))
      end

      def player(player_name)
        Player.new(client, player_name)
      end

      def gods
        id_to_god.values
      end

      def items
        id_to_item.values
      end

      private

      def id_to_item
        return @id_to_item unless @id_to_item.nil?

        @id_to_item = get_items.map do |item_data|
          [item_data['ItemId'], Item.new(item_data)]
        end
        @id_to_item = Hash[@id_to_item]
      end

      def id_to_god
        return @id_to_god unless @id_to_god.nil?

        @id_to_god = get_gods.map do |god_data|
          [god_data['id'], God.new(god_data)]
        end
        @id_to_god = Hash[@id_to_god]
      end

      def name_to_itemid
        return @name_to_itemid unless @name_to_itemid.nil?

        @name_to_itemid = id_to_item.map do |id, item|
          [item.device_name, id]
        end
        @name_to_itemid = Hash[@name_to_itemid]
      end

      def name_to_godid
        return @name_to_godid unless @name_to_godid.nil?

        @name_to_godid = id_to_god.map do |id, god|
          [god.name, id]
        end
        @name_to_godid = Hash[@name_to_godid]
      end

      # /getmatchdetails[ResponseFormat]/{developerId}/{signature}/{session}/{timestamp}/{match_id}
      def match_details(match_id)
        client.api_call('getmatchdetails', [match_id])
      end

      # /getgodsjson/{developerId}/{signature}/{session}/{timestamp}/{languageCode}
      def get_gods
        client.api_call('getgods', [lang_code])
      end

      # /getitemsjson/{developerId}/{signature}/{session}/{timestamp}/{languagecode}
      def get_items
        client.api_call('getitems', [lang_code])
      end
    end
  end
end