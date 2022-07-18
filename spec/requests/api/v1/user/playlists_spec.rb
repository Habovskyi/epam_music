require 'swagger_helper'

RSpec.describe 'api/v1/user/playlists', type: :request do
  path '/api/v1/user/playlists' do
    let(:user) { create(:user) }
    let(:Authorization) { authorization(user) }

    get('user playlists') do
      tags :user_playlists

      security [Bearer: []]
      parameter name: :'includes[]',
                in: :query,
                type: :array,
                collectionFormat: :multi,
                items: {
                  type: :string,
                  enum: Api::V1::Playlist::InfoSerializer.includes
                },
                required: false
      parameter name: :type, in: :query, schema: {
        type: :string, enum: %i[owned shared]
      }, required: false

      describe 'as guest' do
        let(:Authorization) { nil }

        response(401, 'unauthorized') do
          run_test!
        end
      end

      describe 'as user' do
        context 'without shared type' do
          before { create(:playlist, :shared, user:) }

          response(200, 'successful') do
            schema anyOf: [{ '$ref': '#/definitions/public_playlists' }, {}]

            run_test! do
              expect(response.body).to match_response_schema(Api::Schemas::Playlist::MANY_SCHEMA)
            end
          end
        end

        context 'with shared type' do
          before do
            create(:playlist, :shared, user: create(:friendship, :accepted, user_to: user).user_from)
          end

          let(:type) { 'shared' }

          response(200, 'successful') do
            run_test! do
              expect(response.body).to match_response_schema(Api::Schemas::Playlist::MANY_SCHEMA)
            end
          end
        end
      end
    end
  end
end
