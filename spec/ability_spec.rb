require 'spec_helper'

RSpec.describe Smite::Ability do
  let(:agni)      { Smite::Game.god('Agni') }
  let(:smite_obj) { agni.abilities[0] }

  it_behaves_like 'a Smite::Object'
end