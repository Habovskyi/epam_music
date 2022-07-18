require 'swagger_helper'

RSpec.describe 'api/v1/comments', type: :request do
  path '/api/v1/playlists/{playlist_id}/comments' do
    parameter name: :playlist_id, in: :path, type: :string, description: 'playlist_id'
    get('playlist comments') do
      produces 'application/json'
      tags :comments

      security [Bearer: []]
      parameter name: 'includes[]',
                in: :query,
                type: :array,
                collectionFormat: :multi,
                items: {
                  type: :string,
                  enum: Api::V1::Comment::InfoSerializer.includes
                },
                required: false

      let(:Authorization) { nil }

      describe 'as guest' do
        before do
          create(:comment, playlist_id:)
        end

        context 'with public playlist' do
          let(:playlist) { create(:playlist, :general) }
          let(:playlist_id) { playlist.id }

          response(200, 'success') do
            schema anyOf: [{ '$ref': '#/definitions/list_comments' }, {}]

            run_test! do
              expect(response.body).to match_response_schema(Api::Schemas::Comment::MANY_SCHEMA)
            end
          end
        end

        context 'with private playlist' do
          let(:playlist) { create(:playlist, :personal) }
          let(:playlist_id) { playlist.id }

          response(403, 'forbidden') do
            run_test!
          end
        end

        context 'with shared playlist' do
          let(:playlist) { create(:playlist, :shared) }
          let(:playlist_id) { playlist.id }

          response(403, 'forbidden') do
            run_test!
          end
        end
      end

      describe 'as user' do
        let(:user) { create(:user) }
        let(:Authorization) { authorization(user) }

        before do
          create(:comment, playlist_id:)
        end

        context 'with public playlist' do
          let(:playlist) { create(:playlist, :general) }
          let(:playlist_id) { playlist.id }

          response(200, 'success') do
            schema anyOf: [{ '$ref': '#/definitions/list_comments' }, {}]

            run_test! do
              expect(response.body).to match_response_schema(Api::Schemas::Comment::MANY_SCHEMA)
            end
          end
        end

        context 'with private playlist' do
          let(:playlist) { create(:playlist, :personal) }
          let(:playlist_id) { playlist.id }

          response(403, 'forbidden') do
            run_test!
          end
        end

        context 'with own private playlist' do
          let(:playlist) { create(:playlist, :personal, user:) }
          let(:playlist_id) { playlist.id }

          response(200, 'success') do
            schema anyOf: [{ '$ref': '#/definitions/list_comments' }, {}]

            run_test! do
              expect(response.body).to match_response_schema(Api::Schemas::Comment::MANY_SCHEMA)
            end
          end
        end

        context 'with shared playlist' do
          let(:playlist) { create(:playlist, :shared) }
          let(:playlist_id) { playlist.id }

          response(403, 'forbidden') do
            run_test!
          end
        end

        context 'with own shared playlist' do
          let(:playlist) { create(:playlist, :shared, user:) }
          let(:playlist_id) { playlist.id }

          response(200, 'success') do
            schema anyOf: [{ '$ref': '#/definitions/list_comments' }, {}]

            run_test! do
              expect(response.body).to match_response_schema(Api::Schemas::Comment::MANY_SCHEMA)
            end
          end
        end

        context 'with friends shared playlist' do
          let(:playlist) { create(:playlist, :shared, user: create(:friendship, :accepted, user_to: user).user_from) }
          let(:playlist_id) { playlist.id }

          response(200, 'success') do
            schema anyOf: [{ '$ref': '#/definitions/list_comments' }, {}]

            run_test! do
              expect(response.body).to match_response_schema(Api::Schemas::Comment::MANY_SCHEMA)
            end
          end
        end
      end

      context 'with invalid id' do
        let(:playlist_id) { '1234' }

        response(404, 'not found') do
          run_test!
        end
      end
    end

    post('create comment') do
      consumes 'multipart/form-data'
      produces 'application/json'
      tags :comments

      security [Bearer: []]
      parameter name: :text, in: :formData, type: :string, required: true

      let!(:user) { create(:user) }
      let(:Authorization) { authorization(user) }
      let(:text) { 'Comment text' }

      describe 'as guest' do
        let(:Authorization) { nil }

        context 'with public' do
          let!(:playlist_public) { create(:playlist, :general) }
          let(:playlist_id) { playlist_public.id }

          response(401, 'unauthorized') do
            run_test!
          end
        end
      end

      describe 'as user' do
        context 'when have successful access to public playlist' do
          response(200, 'successful') do
            schema anyOf: [{ '$ref': '#/definitions/playlist_comment' }, {}]

            let!(:playlist_public) { create(:playlist, :general) }
            let(:playlist_id) { playlist_public.id }

            run_test! do
              expect(response.body).to match_response_schema(Api::Schemas::Comment::SINGLE_SCHEMA)
            end
          end
        end

        context 'when have successful access to personal playlist' do
          response(200, 'successful') do
            let!(:playlist_personal_own) { create(:playlist, :personal, user:) }
            let(:playlist_id) { playlist_personal_own.id }

            run_test! do
              expect(response.body).to match_response_schema(Api::Schemas::Comment::SINGLE_SCHEMA)
            end
          end
        end

        context 'when have successful access to friend shared playlist' do
          response(200, 'successful') do
            let!(:playlist_shared_friend) do
              create(:playlist, :shared, user: create(:friendship, :accepted, user_to: user).user_from)
            end
            let(:playlist_id) { playlist_shared_friend.id }

            run_test! do
              expect(response.body).to match_response_schema(Api::Schemas::Comment::SINGLE_SCHEMA)
            end
          end
        end

        context 'when unsuccessful responce with access to friend shared playlist' do
          response(422, 'unprocessable_entity') do
            let!(:playlist_shared_friend) do
              create(:playlist, :shared, user: create(:friendship, :accepted, user_to: user).user_from)
            end

            let(:playlist_id) { playlist_shared_friend.id }
            let(:text) { "#{'a' * Api::V1::Comments::CreateForm::TEXT_MAX_LENGTH}a'" }

            run_test!
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
end
