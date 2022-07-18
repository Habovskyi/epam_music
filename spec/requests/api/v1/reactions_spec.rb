RSpec.describe 'api/v1/reactions', type: :request do
  path '/api/v1/playlists/{playlist_id}/reactions' do
    parameter name: :playlist_id, in: :path, type: :string, description: 'Playlist id'

    let(:user) { create(:user) }
    let(:Authorization) { authorization(user) }
    let(:playlist_id) { create(:playlist).id }
    let(:reaction_type) { 'liked' }

    post('create reaction') do
      consumes 'multipart/form-data'
      produces 'application/json'
      parameter name: :reaction_type,
                type: :string,
                in: :formData,
                required: true
      tags :reactions

      security [Bearer: []]

      describe 'as guest' do
        let(:Authorization) { nil }

        response(401, 'unauthorized') do
          run_test!
        end
      end

      describe 'as user' do
        response(200, 'success') do
          schema anyOf: [{ '$ref': '#/definitions/reaction' }, {}]

          run_test! do
            expect(response.body).to match_response_schema(Api::Schemas::Reaction::SINGLE_SCHEMA)
          end
        end

        response(404, 'unauthorized') do
          let(:playlist_id) { 'invalid' }
          run_test!
        end
      end
    end
  end
end
