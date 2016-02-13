require 'spec_helper'

RSpec.describe Smite::GodStats do
  let(:agni)      { Smite::Game.god('agni') }
  let(:smite_obj) { agni.stats }
  let(:items) do
    [
      Smite::Game.item('Soul Reaver'),
      Smite::Game.item('Sovereignty')
    ]
  end

  describe '#initialize' do
    it 'bounds the level between 1 and 20' do
      expect(smite_obj.at_level(300).level).to eq(19)
      expect(smite_obj.at_level(-300).level).to eq(0)
    end
  end

  describe '#at_level' do
    it 'returns a new instance of GodStats at the given level' do
      new_stats = smite_obj.at_level(10)
      expect(new_stats.level).to eq(9)
      expect(new_stats.items).to eq(smite_obj.items)
    end
  end

  describe '#with_items' do
    it 'returns a new instance of GodStats with the given items' do
      new_stats = smite_obj.with_items(items)
      expect(new_stats.items).to eq(items)
      expect(new_stats.level).to eq(smite_obj.level)
    end
  end

  def scaling_calc(stats, attribute)
    from_items  = stats.bonus_from_items[attribute.to_sym]
    base        = stats.data[attribute]
    scaling     = stats.send("#{attribute}_per_level".to_sym).to_f
    scaling     *= stats.level.to_f

    (from_items + base + scaling).round(2)
  end

  %w[ movement_speed health mana
      mp5 hp5 attack_speed magical_power
      magic_protection physical_power physical_protection ].each do |attr|

    describe "##{attr}" do
      it 'returns the base stats at level 0' do
        scaling = scaling_calc(smite_obj, attr)
        expect(smite_obj.send(attr.to_sym)).to eq(scaling)
      end

      it 'returns the scaled stats with items' do
        new_obj = smite_obj.at_level(20).with_items(items)
        scaling = scaling_calc(new_obj, attr)
        expect(new_obj.send(attr.to_sym)).to eq(scaling)
      end
    end
  end

  it_behaves_like 'a Smite::Object'
end