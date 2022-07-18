RSpec.describe 'api/v1/sign_up', type: :request do
  path '/api/v1/sign_up' do
    post('sign_up user') do
      consumes 'application/json'
      produces 'application/json'
      tags :sessions

      security [Bearer: []]
      parameter name: :data,
                in: :body,
                required: true, schema: {
                  '$ref': '#/definitions/user_sign_up'
                }

      response(200, 'successful') do
        schema type: :object,
               '$ref': '#/definitions/tokens_response'

        let(:Authorization) { nil }
        let(:data) { attributes_for(:user) }
        let(:valid) { attributes_for(:user) }

        run_test! do
          expect { post api_v1_sign_up_path, params: valid }.to change(::User, :count).by(+1)
          user_id = JsonWebToken.payload(JSON.parse(response.body)['access_token'])[:user_id]
          expect(User.where(email: valid[:email])).to be_exists(user_id)
        end
      end

      response(400, 'Bad Request') do
        let(:Authorization) { nil }
        let(:data) { attributes_for(:invalid_user) }

        run_test! do
          expect { post '/api/v1/sign_up', params: data }.not_to change(::User, :count)
        end
      end

      response(403, 'Already logged_in') do
        let(:user) { create(:user) }
        let(:Authorization) { authorization(user) }
        let(:data) { nil }

        run_test!
      end
    end

    after do |example|
      example.metadata[:response][:content] = {
        'application/json' => {
          example: JSON.parse(response.body, symbolize_names: true)
        }
      }
    end
  end
end
