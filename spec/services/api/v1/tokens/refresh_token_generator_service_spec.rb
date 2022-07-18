RSpec.describe Api::V1::Tokens::RefreshTokenGeneratorService, type: :service do
  include ActiveSupport::Testing::TimeHelpers

  subject!(:token) { described_class.call(user:) }

  let!(:user) { create(:user) }

  it 'encoding' do
    expect(JsonWebToken.payload(token)[:email]).to eq(user.email)
  end

  it 'expires' do
    travel_to ::User::REFRESH_TOKEN_EXPIRATION.from_now
    expect { JsonWebToken.decode(token) }.to raise_error(JWT::ExpiredSignature)
  end
end
