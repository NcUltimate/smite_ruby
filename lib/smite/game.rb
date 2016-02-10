module Smite
  class Game
    class << self
      attr_reader :client

      def authenticate!(dev_id, auth_key, format = 'json', lang = 1)
        @client = Smite::Client.new(dev_id, auth_key, lang)
        !client.session_id.nil?
      end

      def device(name_or_id)
        idx = device_hash[name_or_id.to_s.downcase]
        idx.nil? ? nil : devices[idx]
      end
      alias_method :item, :device
      alias_method :consumable, :device
      alias_method :active, :device

      def god(name_or_id)
        idx = god_hash[name_or_id.to_s.downcase]
        idx.nil? ? nil : gods[idx]
      end

      def match(match_id)
        match_data = client.match_details(match_id)
        match_data.empty? ? nil : FullMatch.new(match_data)
      end

      def player(player_name_or_id)
        player_data = client.player(player_name_or_id)
        player_data.empty? ? nil : Player.new(player_data[0])
      end

      def motd_now
        motd_list[0]
      end

      def motd_list
        @motds ||= client.motd.map(&MOTD.method(:new))
      end

      def queues
        @queues ||= Smite::Queue::QUEUES.map(&Queue.method(:new))
      end

      def god_recommended_items(name_or_id)
        god = god(name_or_id)
        @rec_items ||= {}
        return @rec_items[god.id] unless @rec_items[god.id].nil?

        @rec_items[god.id] = []
        recommended = client.god_recommended_items(god.id)
        recommended.group_by { |r| r['Role'] }.each do |role, items|
          @rec_items[god.id] << Smite::RecommendedItems.new(god.name, items, role)
        end

        @rec_items[god.id]
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