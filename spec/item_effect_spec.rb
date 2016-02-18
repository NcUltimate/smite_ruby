require 'spec_helper'

RSpec.describe Smite::ItemEffect do
  let(:item)      { Smite::Game.item('Sovereignty') }
  let(:smite_obj) { item.effects[0] }

  describe '#percentage?' do
    it 'returns true if the effect is percentage based' do
      allow(smite_obj).to receive(:percentage).and_return(40)
      expect(smite_obj.percentage?).to eq(true)
    end
    it 'returns false if the effect is not percentage based' do
      allow(smite_obj).to receive(:percentage).and_return(nil)
      expect(smite_obj.percentage?).to eq(false)
    end
  end
end