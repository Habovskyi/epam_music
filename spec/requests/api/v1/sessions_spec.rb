require 'swagger_helper'

RSpec.describe 'api/v1/sessions', type: :request do
  include ActiveSupport::Testing::TimeHelpers

  path '/api/v1/sessions' do
    post('login user') do
      consumes 'application/json'
      produces 'application/json'
      tags :sessions

      security [Bearer: []]
      parameter name: :data,
                in: :body,
                required: true, schema: {
                  type: :object,
                  properties: {
                    email: { type: :string },
                    password: { type: :string }
                  },
                  required: %w[email password]
                }

      let(:Authorization) { nil }
      let(:password) { 'Test_password_123' }
      let!(:user) { create(:user, password:) }
      let(:data) do
        {
          email: user.email,
          password:
        }
      end

      context 'with valid data' do
        response(200, 'successful') do
          schema type: :object,
                 '$ref': '#/definitions/tokens_response'

          run_test!
        end
      end

      context 'with invalid email' do
        response(401, 'Unauthorized') do
          let(:data) { { email: 'invalid', password: } }

          run_test!
        end
      end

      context 'with invalid password' do
        response(401, 'Unauthorized') do
          let(:data) { { email: create(:user).email, password: 'invalid' } }

          run_test!
        end
      end

      context 'with more than one session' do
        before do
          Api::V1::Tokens::RefreshTokenGeneratorService.call(user:) # TODO: Please call session/create service here
        end

        response(200, 'successful') do
          schema type: :object,
                 '$ref': '#/definitions/tokens_response'

          run_test! do
            expect(WhitelistedToken.count).to eq 2
          end
        end
      end
    end

    put('refresh_token session') do
      consumes 'application/x-www-form-urlencoded'
      produces 'application/json'
      tags :sessions

      parameter name: :grand_type, in: :formData, type: :string, required: true
      parameter name: :refresh_token, in: :formData, type: :string, required: true

      response(200, 'successful') do
        schema type: :object,
               '$ref': '#/definitions/tokens_response'

        let(:grand_type) { 'refresh_token' }
        let(:refresh_token) { Api::V1::Tokens::RefreshTokenGeneratorService.call(user: create(:user)) }

        run_test! do
          # TODO: move test to sessions/update_spec
          user_id = JsonWebToken.payload(JSON.parse(response.body)['access_token'])[:user_id]
          refresh_info = JsonWebToken.payload(JSON.parse(response.body)['refresh_token'])
          expect(User.where(id: user_id)).to exist
          expect(User.where(email: refresh_info[:email])).to exist
          expect(WhitelistedToken.count).to eq 1
          expect(WhitelistedToken.first.crypted_token).not_to eq refresh_token
        end
      end

      response(401, 'Invalid token') do
        let!(:user) { create(:user) }
        let(:grand_type) { 'refresh_token' }
        let!(:refresh_token) { Api::V1::Tokens::RefreshTokenGeneratorService.call(user:) }

        context 'with invalid grand_type' do
          let(:grand_type) { 'refresh_tokens' }

          run_test!
        end

        context 'with invalid token' do
          let(:refresh_token) { Api::V1::Tokens::AccessTokenGeneratorService.call(user:) }

          run_test!
        end

        context 'with expired token' do
          before do
            travel_to (::User::REFRESH_TOKEN_EXPIRATION + 1.minute).from_now
          end

          run_test!
        end
      end
    end
  end
end
