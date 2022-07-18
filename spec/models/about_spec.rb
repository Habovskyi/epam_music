RSpec.describe About, type: :model do
  subject(:about) { described_class.create(body:) }

  let(:body) { FFaker::HTMLIpsum.body }

  it 'has propper content' do
    expect(about.body).to eq body
  end
end
