RSpec.describe Api::V1::Tokens::AccessTokenGeneratorService, type: :service do
  include ActiveSupport::Testing::TimeHelpers

  subject!(:token) { described_class.call(user:) }

  let!(:user) { create(:user) }

  it 'encoding' do
    expect(JsonWebToken.payload(token)[:user_id]).to eq(user.id)
  end

  it 'expires' do
    travel_to ::User::ACCESS_TOKEN_EXPIRATION.from_now
    expect { JsonWebToken.decode(token) }.to raise_error(JWT::ExpiredSignature)
  end
end
