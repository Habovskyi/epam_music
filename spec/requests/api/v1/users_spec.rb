RSpec.describe 'api/v1/users', type: :request do
  let(:user) { create(:user) }
  let(:Authorization) { authorization(user) }

  path '/api/v1/users/{id}' do
    get('user') do
      consumes 'application/json'
      produces 'application/json'
      tags :user

      parameter name: :id, in: :path, type: :string, required: true
      security [Bearer: []]
      response(200, 'successful') do
        schema '$ref': '#/definitions/user_response'

        let(:user) { create(:user, active: true) }
        let(:id) { user.id }

        run_test! do
          expect(JSON.parse(response.body)['data']['id']).to eq(id)
        end
      end

      response(401, 'unauthorized') do
        let(:id) { user.id }
        let(:Authorization) { "#{authorization(user)}id" }

        run_test!
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }

        run_test!
      end
    end
  end
  path '/api/v1/user/search_new_user' do
    get('search_new_user current_users') do
      consumes 'application/json'
      produces 'application/json'

      tags :users

      security [Bearer: []]
      parameter name: :email, in: :query, description: 'Search parameter', schema: { type: :string }, required: false
      parameter name: :page, in: :query, schema: { type: :integer }, required: false
      response(200, 'successful') do
        schema type: :object, '$ref': '#/definitions/search_new_user'

        run_test! do
          expect(response.body).to match_response_schema(Api::Schemas::User::MANY_SCHEMA)
        end
      end
    end
  end
end
