module Smite
  class Player < Smite::Object
    attr_reader :client, :player_name

    def initialize(client, player_name)
      @client       = client
      @player_name  = player_name
      @data         = get_player
    end

    def friends
      @friends ||= get_friends.reject { |f| f['name'].empty? }.map(&Friend.method(:new))
    end

    def god_ranks
      @ranks ||= get_god_ranks.map(&GodRank.method(:new))
    end

    def match_history
      @history ||= get_match_history.map(&Match.method(:new))
    end

    def achievements
      @achievements ||= get_achievements
    end

    def inspect
      "#<Smite::Player '#{name}'>"
    end

    private

    # /getplayerachievementsjson/{developerId}/{signature}/{session}/{timestamp}/{playerId}
    def get_achievements
      client.api_call('getplayerachievements', [id])
    end

    # /getfriendsjson/{developerId}/{signature}/{session}/{timestamp}/{player}
    def get_friends
      client.api_call('getfriends', [player_name])
    end

    # /getgodranksjson/{developerId}/{signature}/{session}/{timestamp}/{player}
    def get_god_ranks
      client.api_call('getgodranks', [player_name])
    end

    # /getplayerjson/{developerId}/{signature}/{session}/{timestamp}/{player}
    def get_player
      client.api_call('getplayer', [player_name])[0]
    end

    # /getmatchhistoryjson/{developerId}/{signature}/{session}/{timestamp}/{player}
    def get_match_history
      client.api_call('getmatchhistory', [player_name])
    end
  end
end