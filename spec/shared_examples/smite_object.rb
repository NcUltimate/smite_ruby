RSpec.shared_examples "a Smite::Object" do
  it 'has all underscored data fields' do
    smite_obj.attributes.each do |attr|
      expect(attr).not_to match(/[A-Z]/)
    end
  end

  it 'responds to each data field' do
    smite_obj.attributes.each do |attr|
      expect{ smite_obj.send(attr) }.not_to raise_error
    end
  end

  it 'does not keep ret_msg as an attribute' do
    expect(smite_obj.attributes).not_to include('ret_msg')
  end
end