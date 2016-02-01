require 'rspec'
require 'webmock'

require_relative File.join(File.dirname(__FILE__), '..', 'lib', 'smite.rb')
require_relative File.join(File.dirname(__FILE__), 'shared_examples', 'smite_object.rb')

def response_file(request)
  "#{File.dirname(__FILE__)}/responses/#{request}.json"
end

def response_body(request)
  File.open(response_file(request)).read
end

RSpec.configure do |config|
  config.before do
    WebMock.disable_net_connect! allow_localhost: true
    %w(
      createsession
      testsession
      getdataused
      getgods
      getitems
      getesportsproleaguedetails
      getgodrecommendeditems
      getmatchplayerdetails
      getmatchidsbyqueue
      getleagueseasons
      getleagueleaderboard
      getmotd
      getplayerstatus
      getqueuestats
      getteamdetails
      getteamplayers
      gettopmatches
      getmatchdetails
      getachievements
      getfriends
      getgodranks
      getplayer
      getmatchhistory
      getsearchteams
    ).each do |method|
      WebMock.stub_request(:get, /#{method}/).to_return(
        body: response_body(method),
        headers: { content_type: 'application/json' },
        status: 200
      )
    end
  end
end