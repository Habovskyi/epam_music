RSpec.describe Api::V1::Tokens::TokensGeneratorService, type: :service do
  subject!(:response) { described_class.call(user:) }

  let!(:user) { create(:user) }

  it 'have all fields' do
    expect(response.keys).to contain_exactly(*%i[access_exp refresh_exp refresh_token access_token])
  end
end
