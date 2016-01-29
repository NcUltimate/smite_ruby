module Smite
  class Game
    class << self
      attr_reader :client, :lang_code

      def authenticate!(dev_id, auth_key, lang_code = 1)
        @client     = Smite::Client.new(dev_id, auth_key)
        @lang_code  = lang_code
        !client.session_id.empty?
      end

      def device(name_or_id)
        devices[device_hash[name_or_id]]
      end
      alias_method :item, :device
      alias_method :consumable, :device
      alias_method :active, :device

      def god(name_or_id)
        gods[god_hash[name_or_id]]
      end

      def match(match_id)
        Match.new(match_details(match_id))
      end

      def player(player_name)
        Player.new(client, player_name)
      end

      def gods
        @gods ||= get_gods.map(&God.method(:new))
      end

      def devices
        @devices ||= get_items.map(&Item.method(:new))
      end

      def items
        @items ||= devices.select(&:item?)
      end

      def consumables
        @consumables ||= devices.select(&:consumable?)
      end

      def actives
        @actives ||= devices.select(&:active?)
      end

      private

      def device_hash
        @device_hash ||= (0...devices.count).each_with_object({}) do |idx, hash|
          hash[devices[idx].item_id]      = idx
          hash[devices[idx].device_name]  = idx
        end
      end

      def god_hash
        @god_hash ||= (0...gods.count).each_with_object({}) do |idx, hash|
          hash[gods[idx].id]    = idx
          hash[gods[idx].name]  = idx
        end
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