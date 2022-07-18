RSpec.describe JsonWebToken do
  let(:payload) do
    {
      data: 'test',
      data1: 123
    }.with_indifferent_access
  end

  describe 'payload' do
    it 'can be encoded' do
      expect(described_class.encode(payload)).to be_instance_of(String)
    end

    it 'can be decoded' do
      token = described_class.encode(payload)
      expect(described_class.payload(token)).to match(payload)
    end
  end

  it 'can be expired' do
    token = described_class.encode(payload, 1.minute.ago)
    expect { described_class.decode(token) }.to raise_error(JWT::ExpiredSignature)
  end
end
