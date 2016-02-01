require 'spec_helper'

RSpec.describe Smite::Game do
  let(:dev_id)   { 1234 }
  let(:auth_key) { 'ABCD' }

  before { Smite::Game.authenticate!(dev_id, auth_key) }

  describe '#authenticate!' do
    it 'returns true if the client initialized a session' do
      client = Smite::Client.new(dev_id, auth_key)
      allow(client).to receive(:session_id).and_return('ABCDE')
      allow(Smite::Client).to receive(:new).and_return(client)

      expect(Smite::Game.authenticate!(dev_id, auth_key)).to eq(true)
    end

    it 'returns false if the client did not initialize a session' do
      client = Smite::Client.new(dev_id, auth_key)
      allow(client).to receive(:session_id).and_return(nil)
      allow(Smite::Client).to receive(:new).and_return(client)

      expect(Smite::Game.authenticate!(dev_id, auth_key)).to eq(false)
    end
  end

  describe '#devices' do
    it 'returns a list of Smite::Items' do
      expect(Smite::Game.devices.count).to eq(3)
      Smite::Game.devices.each do |device|
        expect(device.class).to eq(Smite::Item)
      end
    end

    it 'caches the devices' do
      Smite::Game.devices
      expect(Smite::Item).not_to receive(:new)
      Smite::Game.devices
    end
  end

  describe '#items' do
    it 'only returns Items from the device list' do
      Smite::Game.items.each do |item|
        expect(item.type).to eq('Item')
      end
    end

    it 'caches the items' do
      Smite::Game.items
      expect(Smite::Game.devices).not_to receive(:select)
      Smite::Game.items
    end
  end

  describe '#consumables' do
    it 'only returns Consumables from the device list' do
      Smite::Game.consumables.each do |consumable|
        expect(consumable.type).to eq('Consumable')
      end
    end

    it 'caches the consumables' do
      Smite::Game.consumables
      expect(Smite::Game.devices).not_to receive(:select)
      Smite::Game.consumables
    end
  end

  describe '#actives' do
    it 'only returns Actives from the device list' do
      Smite::Game.actives.each do |active|
        expect(active.type).to eq('Active')
      end
    end

    it 'caches the actives' do
      Smite::Game.actives
      expect(Smite::Game.devices).not_to receive(:select)
      Smite::Game.actives
    end
  end

  describe '#gods' do
    it 'returns a list of Smite::God' do
      expect(Smite::Game.gods.count).to eq(1)
      Smite::Game.gods.each do |god|
        expect(god.class).to eq(Smite::God)
      end
    end

    it 'caches the gods' do
      Smite::Game.gods
      expect(Smite::God).not_to receive(:new)
      Smite::Game.gods
    end
  end

  describe '#motd_list' do
    it 'returns a list of Smite::MOTDs' do
      expect(Smite::Game.motd_list.count).to eq(3)
      Smite::Game.motd_list.each do |motd|
        expect(motd.class).to eq(Smite::MOTD)
      end
    end

    it 'is in sorted order by date' do
      motds = Smite::Game.motd_list
      (0..motds.count - 2).each do |k|
        expect(motds[k].date).to be > motds[k+1].date
      end
    end

    it 'caches the motd_list' do
      Smite::Game.motd_list
      expect(Smite::MOTD).not_to receive(:new)
      Smite::Game.motd_list
    end
  end

  describe '#motd_now' do
    it 'returns the most recent MOTD' do
      expect(Smite::Game.motd_now).to eq(Smite::Game.motd_list[0])
    end
  end

  describe '#god' do
    it 'returns a god that matches by name' do
      %w[agni AgNi AGNI].each do |name|
        god = Smite::Game.god(name)
        expect(god.name).to eq('Agni')
      end
    end

    it 'returns a god that matches by id' do
      [1737, '1737'].each do |id|
        god = Smite::Game.god(id)
        expect(god.name).to eq('Agni')
      end
    end

    it 'returns nil for a god that doesnt exist' do
      ['jesus', [], {'Alabama' => :AL }].each do |thing|
        god = Smite::Game.god(thing)
        expect(god).to eq(nil)
      end
    end
  end

  describe '#item' do
    it 'returns an item that matches by name' do
      %w[SOverEIGnty sovereignty SOVEREIGNTY].each do |name|
        item = Smite::Game.item(name)
        expect(item.name).to eq('Sovereignty')
      end
    end

    it 'returns an item that matches by id' do
      [7528, '7528'].each do |id|
        item = Smite::Game.item(id)
        expect(item.name).to eq('Sovereignty')
      end
    end

    it 'returns nil for an item that doesnt exist' do
      ['jesus', [], {'Alabama' => :AL }].each do |thing|
        item = Smite::Game.item(thing)
        expect(item).to eq(nil)
      end
    end
  end

  describe '#player' do
    it 'instantiates a new Smite::Player' do
      expect(Smite::Player).to receive(:new)
      Smite::Game.player('adapting')
    end
  end

  describe '#queues' do
    it 'returns a list of queues' do
      expect(Smite::Game.queues.count).to eq(9)
      Smite::Game.queues.each do |queue|
        expect(queue.class).to eq(Smite::Queue)
      end
    end

    it 'caches the queue list' do
      Smite::Game.queues
      expect(Smite::Queue).not_to receive(:new)
      Smite::Game.queues
    end
  end

  describe '#match' do
    it 'instantiates a new Smite::Match' do
      # pending
    end
  end
end