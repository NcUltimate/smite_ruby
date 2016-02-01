module Smite
  class Client
    attr_reader :dev_id, :auth_key, :session_id, :lang
    include HTTParty
    base_uri 'http://api.smitegame.com/smiteapi.svc/'

    def initialize(dev_id, auth_key, lang = 1)
      @dev_id     = dev_id
      @auth_key   = auth_key
      @lang       = [1,2,3,7,9,10,11,12,13].include?(lang) ? lang : 1
      create_session
    end

    def esports_pro_league_details
      api_call('getesportsproleaguedetails')
    end

    def god_recommended_items(god_id)
      api_call('getgodrecommendeditems', [god_id, lang])
    end

    def match_player_details(match_id)
      api_call('getmatchplayerdetails', [match_id])
    end

    def match_ids_by_queue(queue, date, hour)
      api_call('getmatchidsbyqueue', [queue, date, hour])
    end

    def league_seasons(queue)
      api_call('getleagueseasons', [queue])
    end

    def league_leaderboard(queue, tier, season)
      api_call('getleagueleaderboard', [queue, tier, season])
    end

    def motd
      api_call('getmotd')
    end

    def player_status(player_name)
      api_call('getplayerstatus', [player_name])
    end

    def queue_stats(player_name, queue)
      api_call('getqueuestats', [player_name, queue])
    end

    def team_details(clan_id)
      api_call('getteamdetails', [clan_id])
    end

    def team_players(clan_id)
      api_call('getteamplayers', [clan_id])
    end

    def top_matches
      api_call('gettopmatches')
    end

    def match_details(match_id)
      api_call('getmatchdetails', [match_id])
    end

    def gods
      api_call('getgods', [lang])
    end

    def items
      api_call('getitems', [lang])
    end

    def achievements(player_id)
      api_call('getplayerachievements', [player_id])
    end

    def friends(player_name)
      api_call('getfriends', [player_name])
    end

    def god_ranks(player_name)
      api_call('getgodranks', [player_name])
    end

    def player(player_name)
      api_call('getplayer', [player_name])
    end

    def match_history(player_name)
      api_call('getmatchhistory', [player_name])
    end

    def search_teams(team_name)
      api_call('searchteams', [team_name])
    end

    def test_session
      api_call('testsession')
    end

    def data_used
      api_call('getdataused')
    end

    def create_session
      return @session_id if valid_session?

      response    = api_call('createsession', [], false)
      @session_id = response['session_id']
    end

    def valid_session?
      !!(test_session =~ /successful/i)
    end

    private

    def api_call(method, params = [], session = true)
      request = request_str(method, params, session)
      self.class.get(request)
    end

    def signature(method)
      Digest::MD5.hexdigest("#{dev_id}#{method}#{auth_key}#{timestamp}")
    end

    # current utc timestamp (formatted yyyyMMddHHmmss)
    def timestamp
      Time.now.utc.strftime('%Y%m%d%H%M%S')
    end

    def request_str(method, params, session)
      base  = base_str(method)
      parm  = param_str(params)
      sess  = session_str(session)

      "#{base}#{sess}#{parm}".chomp('/')
    end

    def base_str(method)
      signature = signature(method)
      "/#{method}json/#{dev_id}/#{signature}"
    end

    def param_str(params)
      "/#{params.join('/')}"
    end

    def session_str(session)
      "/#{session_id}#{session ? '/' : ''}#{timestamp}"
    end
  end
end