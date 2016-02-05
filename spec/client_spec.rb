require 'spec_helper'

RSpec.describe Smite::Client do
  let(:dev_id)   { 1234 }
  let(:auth_key) { 'ABCD' }

  describe '#initialize' do
    it 'accepts only valid languages' do
      [1,2,3,7,9,10,11,12,13].each do |lang|
        client = described_class.new(dev_id, auth_key, lang)
        expect(client.lang).to eq(lang)
      end
    end

    it 'defaults the langauge to English' do
      [14..20].each do |lang|
        client = described_class.new(dev_id, auth_key, lang)
        expect(client.lang).to eq(1)
      end
    end
  end

  describe '#valid_session?' do
    let(:client) { described_class.new(dev_id, auth_key) }

    it 'returns true if the session is created' do
      expect(client.valid_session?).to eq(true)
    end

    it 'returns false if the session is not created' do
      allow(client).to receive(:created).and_return(Time.now - 20 * 60)
      expect(client.valid_session?).to eq(false)
    end
  end

  describe '#create_session' do
    let(:client) { described_class.new(dev_id, auth_key) }

    it 'sets the session_id on initialize' do
      expect(client.session_id).not_to be_nil
    end

    it 'returns the session_id if set' do
      allow(client).to receive(:valid_session?).and_return(true)
      expect(client).not_to receive(:api_call)
      client.create_session
    end
  end
end