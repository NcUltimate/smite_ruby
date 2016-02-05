require 'spec_helper'

RSpec.describe Smite::God do
  let(:osiris)    { Smite::Game.god('Osiris') }
  let(:sobek)     { Smite::Game.god('Sobek') }
  let(:agni)      { Smite::Game.god('Agni') }
  let(:smite_obj) { agni }

  describe '#on_free_rotation?' do
    it 'returns true if not empty' do
      expect(agni.on_free_rotation?).to eq(true)
    end
    it 'returns false if empty' do
      expect(sobek.on_free_rotation?).to eq(false)
    end
  end

  describe '#ranged?' do
    it 'returns true if type contains Ranged' do
      expect(agni.ranged?).to eq(true)
    end
    it 'returns false if type does not contain Ranged' do
      expect(sobek.ranged?).to eq(false)
    end
  end

  describe '#melee?' do
    it 'returns true if type contains Melee' do
      expect(sobek.melee?).to eq(true)
    end
    it 'returns false if type does not contain Melee' do
      expect(agni.melee?).to eq(false)
    end
  end

  describe '#magic?' do
    it 'returns true if type contains Magic' do
      expect(agni.magic?).to eq(true)
    end
    it 'returns false if type does not contain Magic' do
      expect(osiris.magic?).to eq(false)
    end
  end

  describe '#physical?' do
    it 'returns true if type contains Physical' do
      expect(osiris.physical?).to eq(true)
    end
    it 'returns false if type does not contain Physical' do
      expect(agni.physical?).to eq(false)
    end
  end

  it_behaves_like 'a Smite::Object'
end