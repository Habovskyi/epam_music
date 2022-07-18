require 'swagger_helper'

RSpec.describe 'api/v1/current_user', type: :request do
  path '/api/v1/current_user' do
    get('current user') do
      consumes 'application/json'
      produces 'application/json'
      tags :user

      security [Bearer: []]

      context 'when valid values' do
        response(200, 'successful') do
          schema '$ref': '#/definitions/user_response'

          let(:user) { create(:user) }
          let(:Authorization) { authorization(user) }

          run_test! do
            expect(JSON.parse(response.body)['data']['id']).to eq(user.id)
          end
        end
      end

      context 'when unauthorized' do
        response(401, 'unauthorized') do
          let(:Authorization) { "#{authorization(create(:user))}id" }

          run_test!
        end
      end
    end

    put('update current_user') do
      consumes 'multipart/form-data'
      produces 'application/json'
      tags :user

      security [Bearer: []]
      parameter name: :id, in: :path, type: :string, required: true
      parameter name: :first_name, in: :formData, type: :string, required: false
      parameter name: :last_name, in: :formData, type: :string, required: false
      parameter name: :username, in: :formData, type: :string, required: false
      parameter name: :avatar, in: :formData, type: :file, required: false

      context 'when update first and last names' do
        response(200, 'successful') do
          schema '$ref': '#/definitions/user_response'
          let(:user) { create(:user) }
          let(:id) { user.id }
          let(:first_name) { 'Michael' }
          let(:last_name) { 'Jackson' }

          let(:Authorization) { authorization(user) }

          run_test! do
            expect(JSON.parse(response.body)['data']['attributes']['first_name']).to eq(first_name)
            expect(JSON.parse(response.body)['data']['attributes']['last_name']).to eq(last_name)
          end
        end
      end

      context 'when update username and avatar' do
        response(200, 'successful') do
          schema '$ref': '#/definitions/user_response'
          let(:user) { create(:user) }
          let(:id) { user.id }
          let(:username) { 'user123' }
          let(:avatar) { fixture_file_upload('spec/fixtures/avatar/test_avatar.png') }

          let(:Authorization) { authorization(user) }

          run_test! do
            expect(JSON.parse(response.body)['data']['attributes']['username']).to eq(username)
            expect(user.reload.avatar).to exist
          end
        end
      end

      context 'when unauthorized' do
        response(401, 'unauthorized') do
          let(:user) { create(:user) }
          let(:id) { user.id }
          let(:Authorization) { "#{authorization(user)}id" }

          run_test!
        end
      end
    end

    delete('user') do
      tags :user
      security [Bearer: []]
      response(204, 'successful') do
        let(:user) { create(:user) }
        let(:Authorization) { authorization(user) }

        run_test! do
          expect(user).to be_active
        end
      end
    end
  end
end
