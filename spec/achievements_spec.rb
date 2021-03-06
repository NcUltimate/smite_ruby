require 'spec_helper'

RSpec.describe Smite::Achievements do
  let(:player)    { Smite::Game.player('adapting') }
  let(:smite_obj) { player.achievements }

  it_behaves_like 'a Smite::Object'
end