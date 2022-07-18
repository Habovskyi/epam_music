require 'swagger_helper'

RSpec.describe 'api/v1/playlists/{playlist_id}/songs', type: :request do
  path '/api/v1/playlists/{playlist_id}/songs' do
    parameter name: 'playlist_id', in: :path, type: :string, description: 'playlist_id'

    get('playlist songs') do
      tags :playlist_songs

      security [Bearer: []]
      parameter name: :'includes[]',
                in: :query,
                type: :array,
                collectionFormat: :multi,
                items: {
                  type: :string,
                  enum: Api::V1::PlaylistSong::InfoSerializer.includes
                },
                required: false

      describe 'as guest' do
        let(:Authorization) { nil }

        context 'with public' do
          let(:playlist_id) { create(:playlist_with_songs, :general, count: 1).id }

          response(200, 'successful') do
            schema anyOf: [{ '$ref': '#/definitions/playlist_songs' }, {}]

            run_test! do
              expect(response.body).to match_response_schema(Api::Schemas::PlaylistSong::DEFAULT_SCHEMA)
            end
          end
        end

        context 'with private' do
          let(:playlist_id) { create(:playlist_with_songs, :personal, count: 1).id }

          response(403, 'fail') do
            run_test!
          end
        end

        context 'with shared' do
          let(:playlist_id) { create(:playlist_with_songs, :shared, count: 1).id }

          response(403, 'fail') do
            run_test!
          end
        end

        context 'with corrupted id' do
          let(:playlist_id) { 'id' }

          response(404, 'not found') do
            run_test!
          end
        end
      end

      describe 'as user' do
        let(:user) { create(:user) }
        let(:Authorization) { authorization(user) }

        context 'with access when general playlist' do
          response(200, 'successful') do
            let(:playlist_id) { create(:playlist_with_songs, :general, count: 1).id }

            run_test! do
              expect(response.body).to match_response_schema(Api::Schemas::PlaylistSong::DEFAULT_SCHEMA)
            end
          end
        end

        context 'with access when personal playlist' do
          response(200, 'successful') do
            let(:playlist_id) { create(:playlist_with_songs, :personal, user:, count: 1).id }

            run_test! do
              expect(response.body).to match_response_schema(Api::Schemas::PlaylistSong::DEFAULT_SCHEMA)
            end
          end
        end

        context 'with access when shared friend playlist' do
          response(200, 'successful') do
            let(:playlist_id) do
              create(:playlist_with_songs, :shared,
                     count: 1, user: create(:friendship, :accepted, user_to: user).user_from).id
            end

            run_test! do
              expect(response.body).to match_response_schema(Api::Schemas::PlaylistSong::SHARED_SCHEMA)
            end
          end
        end

        context 'without access' do
          response(403, 'access denied') do
            let(:playlist_id) { create(:playlist, :personal).id }

            run_test!
          end

          response(403, 'access denied') do
            let(:playlist_id) { create(:playlist, :shared).id }

            run_test!
          end
        end
      end
    end
  end

  path '/api/v1/playlists/{playlist_id}/songs' do
    post('create playlist_song') do
      consumes 'application/json'
      produces 'application/json'
      tags :playlist_songs

      security [Bearer: []]

      parameter name: :playlist_id, in: :path, type: :string, required: true
      parameter name: :playlist_song,
                in: :body,
                required: true, schema: {
                  type: :object,
                  properties: {
                    song_id: { type: :string }
                  },
                  required: %w[song_id]
                }

      let(:user) { create(:user) }
      let(:Authorization) { authorization(user) }

      describe 'as guest' do
        context 'when unauthorized' do
          let(:Authorization) { '' }
          let(:playlist_id) { create(:playlist, user:).id }
          let(:playlist_song) { { song_id: create(:song).id } }

          response(401, 'unauthorized') do
            run_test!
          end
        end
      end

      describe 'edit friend playlist' do
        context 'when shared playlist' do
          response(200, 'success') do
            schema anyOf: [{ '$ref': '#/definitions/playlist_song_shared' }, {}]

            let(:playlist_id) do
              create(:playlist, :shared, user: create(:accepted_friendship, user_to: user).user_from).id
            end

            let(:playlist_song) { { song_id: create(:song).id } }

            run_test! do
              expect(response.body).to match_response_schema(Api::Schemas::PlaylistSong::SINGLE_SHARED_SCHEMA)
              expect(PlaylistSong.count).to eq(1)
            end
          end
        end

        context 'when not shared playlist' do
          response(404, 'not found') do
            let(:playlist_id) do
              create(:playlist, :general, user: create(:accepted_friendship, user_to: user).user_from).id
            end

            let(:playlist_song) { { song_id: create(:song).id } }

            run_test!
          end
        end
      end

      describe 'edit own playlists' do
        context 'when success' do
          let(:playlist_id) { create(:playlist, user:).id }
          let(:playlist_song) { { song_id: create(:song).id } }

          response(200, 'success') do
            schema anyOf: [{ '$ref': '#/definitions/playlist_song' }, {}]

            run_test! do
              expect(response.body).to match_response_schema(Api::Schemas::PlaylistSong::SINGLE_DEFAULT_SCHEMA)
              expect(PlaylistSong.count).to eq(1)
            end
          end
        end

        context 'when duplicate' do
          let(:song) { create(:playlist_song, playlist: create(:playlist, user:), user:) }
          let(:playlist_id) { song.playlist_id }
          let(:playlist_song) { { song_id: song.id } }

          response(400, 'bad request') do
            schema type: :object,
                   properties: {
                     errors: { type: :object }
                   }

            run_test! do
              expect(PlaylistSong.count).to eq(1)
            end
          end
        end

        context 'when corrupted id' do
          let(:playlist_id) { 'playlist_id' }
          let(:playlist_song) { { song_id: 'some_id' } }

          response(404, 'not found') do
            run_test!
          end
        end
      end
    end
  end

  path '/api/v1/playlists/{playlist_id}/songs/{id}' do
    delete('delete playlist_songs') do
      consumes 'application/json'
      produces 'application/json'
      tags :playlist_songs
      parameter name: 'playlist_id',
                in: :path,
                type: :string,
                description: 'playlist id',
                required: true
      parameter name: 'id',
                in: :path,
                type: :string,
                description: 'song id',
                required: true

      context 'when delete playlist song' do
        let(:user) { create(:user) }
        let(:Authorization) { authorization(user) }
        let(:playlist_id) { create(:playlist, user:).id }
        let(:id) { create(:playlist_song, playlist_id:).song_id }

        security [Bearer: []]

        response(204, 'no content') do
          run_test! do
            expect(PlaylistSong).not_to be_exist(id:)
          end
        end

        response(404, 'not found') do
          let(:id) { 'invalid' }

          run_test!
        end

        response(401, 'unauthorized') do
          let(:Authorization) { 'Bearer invalid' }

          run_test!
        end
      end
    end
  end
end
