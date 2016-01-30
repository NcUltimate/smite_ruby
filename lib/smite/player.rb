module Smite
  class Player < Smite::Object
    attr_reader :client, :player_name

    def initialize(client, player_name)
      @client       = client
      @player_name  = player_name
      super(client.get_player(player_name))
    end

    def friends
      return @friends unless @friends.nil?

      @friends = client.friends(player_name)
      @friends = @friends.reject { |f| f['name'].empty? }
      @friends.map!(&Friend.method(:new))
    end

    def god_ranks
      return @ranks unless @ranks.nil?

      @ranks = client.god_ranks(player_name)
      @ranks.map!(&GodRank.method(:new))
    end

    def match_history
      return @history unless @history.nil?

      @history = client.match_history(player_name)
      @history.map!(&Match.method(:new))
    end

    def achievements
      return @achievements unless @achievements.nil?

      achievements  = client.achievements(id)
      @achievements = Achievements.new(achievements)
    end

    def inspect
      "#<Smite::Player '#{name}'>"
    end
  end
end