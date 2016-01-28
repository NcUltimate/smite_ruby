module Smite
  class Client
    attr_reader :dev_id, :auth_key, :session_id
    include HTTParty
    base_uri 'http://api.smitegame.com/smiteapi.svc/'

    def initialize(dev_id, auth_key)
      @dev_id     = dev_id
      @auth_key   = auth_key
      create_session
    end

    # /testsessionjson/{developerId}/{signature}/{session}/{timestamp}
    def test_session
      api_call('testsession', [])
    end

    # /getdatausedjson/{developerId}/{signature}/{session}/{timestamp}
    def get_data_used
      api_call('getdataused', [])
    end

    # /createsessionjson/{developerId}/{signature}/{timestamp}
    def create_session
      return @session_id if valid_session?

      response    = api_call('createsession', [], false)
      @session_id = response['session_id']
    end

    def api_call(method, params = [], session = true)
      request = request_str(method, params, session)
      self.class.get(request)
    end

    private

    def signature(method)
      Digest::MD5.hexdigest("#{dev_id}#{method}#{auth_key}#{timestamp}")
    end

    # current utc timestamp (formatted yyyyMMddHHmmss)
    def timestamp
      Time.now.utc.strftime('%Y%m%d%H%M%S')
    end

    def valid_session?
      test_session =~ /successful/i
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