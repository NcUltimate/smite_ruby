require 'spec_helper'

RSpec.describe Smite::RecentMatch do
  let(:player)    { Smite::Game.player('adapting') }
  let(:smite_obj) { player.match_history[0] }

  it_behaves_like 'a Smite::Object'
end