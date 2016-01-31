module Smite
  class Game
    class << self
      attr_reader :client

      def authenticate!(dev_id, auth_key, format = 'json', lang = 1)
        @client = Smite::Client.new(dev_id, auth_key, format, lang)
        !client.session_id.empty?
      end

      def device(name_or_id)
        devices[device_hash[name_or_id.to_s.downcase]]
      end
      alias_method :item, :device
      alias_method :consumable, :device
      alias_method :active, :device

      def god(name_or_id)
        gods[god_hash[name_or_id.to_s.downcase]]
      end

      def match(match_id)
        Match.new(client.match_details(match_id))
      end

      def player(player_name)
        Player.new(client, player_name)
      end

      # role in %w[Standard Arena Tutorial]
      def god_recommended_items(name_or_id, role = 'Standard')
        god   = god(name_or_id)
        role  = role.downcase
        
        @rec_items          ||= {}
        @rec_items[god.id]  ||= {}
        return @rec_items[god.id][role] unless @rec_items[god.id][role].nil?

        recommended = client.god_recommended_items(god.id)
        @rec_items[god.id][role.downcase] ||= Smite::RecommendedItems.new(god.name, recommended, role)
      end

      def gods
        @gods ||= client.gods.map(&God.method(:new))
      end

      def devices
        @devices ||= client.items.map(&Item.method(:new))
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
          hash[devices[idx].item_id.to_s]          = idx
          hash[devices[idx].device_name.downcase]  = idx
        end
      end

      def god_hash
        @god_hash ||= (0...gods.count).each_with_object({}) do |idx, hash|
          hash[gods[idx].id.to_s]        = idx
          hash[gods[idx].name.downcase]  = idx
        end
      end
    end
  end
end