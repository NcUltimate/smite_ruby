require 'spec_helper'

RSpec.describe Smite::Item do
  let(:vampiric_shroud) { Smite::Game.item("Vampiric Shroud") }
  let(:shifters_shield) { Smite::Game.item("Shifter's Shield") }
  let(:iron_mail)       { Smite::Game.item('Iron Mail') }
  let(:soul_reaver)     { Smite::Game.item('Soul Reaver') }
  let(:sovereignty)     { Smite::Game.item('Sovereignty') }
  let(:aegis)           { Smite::Game.item('Improved Aegis') }
  let(:potion)          { Smite::Game.item('Potion of Magical Might') }
  let(:smite_obj)       { sovereignty }

  describe '#active?' do
    it 'returns true if the device is an active' do
      expect(aegis.active?).to eq(true)
    end
    it 'returns false if the device is not an active' do
      expect(sovereignty.active?).to eq(false)
      expect(potion.active?).to eq(false)
    end
  end

  describe '#consumable?' do
    it 'returns true if the device is a consumable' do
      expect(potion.consumable?).to eq(true)
    end
    it 'returns false if the device is not a consumable' do
      expect(sovereignty.consumable?).to eq(false)
      expect(aegis.consumable?).to eq(false)
    end
  end

  describe '#item?' do
    it 'returns true if the device is an item' do
      expect(sovereignty.item?).to eq(true)
    end
    it 'returns false if the device is not an item' do
      expect(potion.item?).to eq(false)
      expect(aegis.item?).to eq(false)
    end
  end

  describe '#physical?' do
    it 'returns true if the device is a physical item' do
      expect(sovereignty.physical?).to eq(true)
      expect(shifters_shield.physical?).to eq(true)
    end
    it 'returns true if the device is an active or potion' do
      expect(potion.physical?).to eq(true)
      expect(aegis.physical?).to eq(true)
    end
    it 'returns false if the device is physical' do
      expect(soul_reaver.physical?).to eq(false)
    end
  end

  describe '#magic?' do
    it 'returns true if the device is a magic item' do
      expect(soul_reaver.magic?).to eq(true)
      expect(sovereignty.magic?).to eq(true)
    end
    it 'returns true if the device is an active or potion' do
      expect(potion.physical?).to eq(true)
      expect(aegis.physical?).to eq(true)
    end
    it 'returns false if the device is magic' do
      expect(shifters_shield.magic?).to eq(false)
    end
  end

  describe '#starter?' do
    it 'returns true if the device is a starter item' do
      expect(vampiric_shroud.starter?).to eq(true)
    end
    it 'returns false otherwise' do
      expect(potion.starter?).to eq(false)
      expect(aegis.starter?).to eq(false)
      expect(soul_reaver.starter?).to eq(false)
      expect(sovereignty.starter?).to eq(false)
    end
  end

  describe '#passive?' do
    it 'returns true if the item has a passive' do
      expect(soul_reaver.passive?).to eq(true)
      expect(sovereignty.passive?).to eq(true)
      expect(aegis.passive?).to eq(true)
      expect(potion.passive?).to eq(true)
    end
    it 'returns false if the item does not have a passive' do
      expect(iron_mail.passive?).to eq(false)
    end
  end

  describe '#aura?' do
    it 'returns true if the item give off an aura' do
      expect(sovereignty.aura?).to eq(true)
    end
    it 'returns false if the item does not have a passive' do
      expect(aegis.aura?).to eq(false)
      expect(potion.aura?).to eq(false)
      expect(soul_reaver.aura?).to eq(false)
      expect(iron_mail.aura?).to eq(false)
    end
  end

  it_behaves_like 'a Smite::Object'
end