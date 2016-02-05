require 'spec_helper'

RSpec.describe Smite::Friend do
  let(:player)    { Smite::Game.player('adapting') }
  let(:smite_obj) { player.friends[0] }

  describe '#to_player' do
    it 'returns a Smite::Player instance of this friend' do
      expect(smite_obj.to_player.class).to eq(Smite::Player)
    end
  end

  it_behaves_like 'a Smite::Object'
end