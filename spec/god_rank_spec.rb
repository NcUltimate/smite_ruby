require 'spec_helper'

RSpec.describe Smite::GodRank do
  let(:player)    { Smite::Game.player('adapting') }
  let(:smite_obj) { player.god_ranks[0] }

  describe '#level' do
    let(:rank_map)  do
      {
        0 => 'none',
        1 => 'gold',
        2 => 'gold',
        3 => 'gold',
        4 => 'gold',
        5 => 'legendary',
        6 => 'legendary',
        7 => 'legendary',
        8 => 'legendary',
        9 => 'legendary',
        10 => 'diamond'
      }
    end

    it 'returns the correct rank for each god level' do
      rank_map.each do |rank, level|
        allow(smite_obj).to receive(:rank).and_return(rank)
        expect(smite_obj.level).to eq(level)
      end
    end
  end

  describe '#mastery' do
    it 'returns unmastered for rank 0' do
      allow(smite_obj).to receive(:rank).and_return(0)
      expect(smite_obj.mastery).to eq('unmastered')
    end

    it 'returns mastered for all other ranks' do
      (1..10).each do |rank|
        allow(smite_obj).to receive(:rank).and_return(rank)
        expect(smite_obj.mastery).to eq('mastered')
      end
    end
  end

  describe '#mastered?' do
    it 'returns true if the rank is > 0' do
      (1..10).each do |rank|
        allow(smite_obj).to receive(:rank).and_return(rank)
        expect(smite_obj.mastered?).to eq(true)
      end
    end
    it 'returns false if the rank is == 0' do
      allow(smite_obj).to receive(:rank).and_return(0)
      expect(smite_obj.mastered?).to eq(false)
    end
  end

  it_behaves_like 'a Smite::Object'
end