require 'spec_helper'

RSpec.describe Smite::MatchSummary do
  let(:player)    { Smite::Game.player('adapting') }
  let(:smite_obj) { player.match_history[0] }

  describe '#to_full_match' do
    it 'returns a Smite::FullMatch version of this object' do
      expect(smite_obj.to_full_match.class).to eq(Smite::FullMatch)
    end

    it 'is also known as #full_match' do
      expect(smite_obj).to respond_to(:full_match)
    end
  end

  describe '#win?' do
    it 'returns true if the match was a win' do
      expect(smite_obj.win?).to eq(true)
    end
    it 'returns false if the match was a loss' do
      allow(smite_obj).to receive(:win_status).and_return('Loss')
      expect(smite_obj.win?).to eq(false)
    end
  end

  it_behaves_like 'a Smite::Object'
end