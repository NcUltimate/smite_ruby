require 'spec_helper'

RSpec.describe Smite::God do
  let(:osiris)    { Smite::Game.god('Osiris') }
  let(:sobek)     { Smite::Game.god('Sobek') }
  let(:agni)      { Smite::Game.god('Agni') }
  let(:rama)      { Smite::Game.god('Rama') }
  let(:loki)      { Smite::Game.god('Loki') }
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

  describe '#hunter?' do
    it 'returns true if the god is a hunter' do
      expect(rama.hunter?).to eq(true)
    end
    it 'returns false if the god is not a hunter' do
      expect(osiris.hunter?).to eq(false)
      expect(agni.hunter?).to eq(false)
      expect(loki.hunter?).to eq(false)
      expect(sobek.hunter?).to eq(false)
    end
  end

  describe '#assassin?' do
    it 'returns true if the god is an assassin' do
      expect(loki.assassin?).to eq(true)
    end
    it 'returns false if the god is not an assassin' do
      expect(osiris.assassin?).to eq(false)
      expect(agni.assassin?).to eq(false)
      expect(rama.assassin?).to eq(false)
      expect(sobek.assassin?).to eq(false)
    end
  end

  describe '#guardian?' do
    it 'returns true if the god is a guardian' do
      expect(sobek.guardian?).to eq(true)
    end
    it 'returns false if the god is not a guardian' do
      expect(osiris.guardian?).to eq(false)
      expect(agni.guardian?).to eq(false)
      expect(loki.guardian?).to eq(false)
      expect(rama.guardian?).to eq(false)
    end
  end

  describe '#mage?' do
    it 'returns true if the god is a mage' do
      expect(agni.mage?).to eq(true)
    end
    it 'returns false if the god is not a mage' do
      expect(osiris.mage?).to eq(false)
      expect(rama.mage?).to eq(false)
      expect(loki.mage?).to eq(false)
      expect(sobek.mage?).to eq(false)
    end
  end

  describe '#warrior?' do
    it 'returns true if the god is a warrior' do
      expect(osiris.warrior?).to eq(true)
    end
    it 'returns false if the god is not a warrior' do
      expect(rama.warrior?).to eq(false)
      expect(agni.warrior?).to eq(false)
      expect(loki.warrior?).to eq(false)
      expect(sobek.warrior?).to eq(false)
    end
  end

  it_behaves_like 'a Smite::Object'
end