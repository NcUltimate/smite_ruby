module Smite
  class Player < Smite::Object
    attr_reader :player_name

    def initialize(data)
      super(data)
      @player_name = name.match(/\A(\[.+?\])?(.+)/)[2]
    end

    def friends
      return @friends unless @friends.nil?

      @friends = Smite::Game.client.friends(player_name)
      @friends = @friends.reject { |f| f['name'].empty? }
      @friends.map!(&Friend.method(:new))
    end

    def god_ranks
      return @ranks unless @ranks.nil?

      @ranks = Smite::Game.client.god_ranks(player_name)
      @ranks.map!(&GodRank.method(:new))
    end

    def match_history
      return @history unless @history.nil?

      @history = Smite::Game.client.match_history(player_name)
      @history.map!(&MatchSummary.method(:new))
    end

    def achievements
      return @achievements unless @achievements.nil?

      achievements  = Smite::Game.client.achievements(id)
      @achievements = Achievements.new(achievements)
    end

    def inspect
      "#<Smite::Player '#{name}'>"
    end
  end
end