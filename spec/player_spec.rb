require 'spec_helper'

RSpec.describe Smite::Player do
  let(:player)    { Smite::Game.player('adapting') }
  let(:smite_obj) { player }

  before { Smite::Game.authenticate!(1234, 'ABCD') }

  describe '#friends' do
    it 'only includes friends with a non-empty name' do
      expect(player.friends.count).to eq(5)
      player.friends.each do |friend|
        expect(friend.name).not_to be_empty
      end
    end

    it 'creates new Smite::Friend objects' do
      expect(player.friends.count).to eq(5)
      player.friends.each do |friend|
        expect(friend.class).to eq(Smite::Friend)
      end
    end

    it 'caches the friends' do
      player.friends
      expect(Smite::Game.client).not_to receive(:friends)
      expect(Smite::Friend).not_to receive(:new)
      player.friends
    end
  end

  describe '#god_ranks' do
    it 'creates new Smite::GodRank objects' do
      player.god_ranks.each do |god_rank|
        expect(god_rank.class).to eq(Smite::GodRank)
      end
    end

    it 'caches the god_ranks' do
      player.god_ranks
      expect(Smite::Game.client).not_to receive(:god_ranks)
      expect(Smite::GodRank).not_to receive(:new)
      player.god_ranks
    end
  end

  describe '#match_history' do
    it 'creates new Smite::RecentMatch objects' do
      player.match_history.each do |match|
        expect(match.class).to eq(Smite::RecentMatch)
      end
    end

    it 'caches the match_history' do
      player.match_history
      expect(Smite::Game.client).not_to receive(:match_history)
      expect(Smite::RecentMatch).not_to receive(:new)
      player.match_history
    end
  end

  describe '#achievements' do
    it 'creates new Smite::Achievements objects' do
      expect(player.achievements.class).to eq(Smite::Achievements)
    end

    it 'caches the achievements' do
      player.achievements
      expect(Smite::Game.client).not_to receive(:achievements)
      expect(Smite::Achievements).not_to receive(:new)
      player.achievements
    end
  end

  it_behaves_like 'a Smite::Object'
end