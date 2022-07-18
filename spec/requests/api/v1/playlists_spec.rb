require 'swagger_helper'
require 'sidekiq/testing'

RSpec.describe 'api/v1/playlists', type: :request do
  path '/api/v1/playlists/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'id'
    get('show playlist') do
      tags :playlists

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

      describe 'as guest' do
        let(:Authorization) { nil }

        context 'with public' do
          let(:id) { create(:playlist, :general).id }

          response(200, 'successful') do
            schema type: :object,
                   '$ref': '#/definitions/playlist'

            run_test! do
              expect(response.body).to match_response_schema(Api::Schemas::Playlist::SINGLE_SCHEMA)
            end
          end
        end

        context 'with private' do
          let(:id) { create(:playlist, :personal).id }

          response(403, 'fail') do
            run_test!
          end
        end

        context 'with shared' do
          let(:id) { create(:playlist, :shared).id }

          response(403, 'fail') do
            run_test!
          end
        end

        context 'with corrupted id' do
          let(:id) { FFaker::Lorem.word }

          response(404, 'not found') do
            run_test!
          end
        end
      end

      describe 'as user' do
        let(:user) { create(:user) }
        let(:Authorization) { authorization(user) }

        context 'with access' do
          response(200, 'successful') do
            let(:id) { create(:playlist, :general).id }

            run_test! do
              expect(response.body).to match_response_schema(Api::Schemas::Playlist::SINGLE_SCHEMA)
            end
          end

          response(200, 'successful') do
            let(:id) { create(:playlist, :personal, user:).id }

            run_test! do
              expect(response.body).to match_response_schema(Api::Schemas::Playlist::SINGLE_SCHEMA)
            end
          end

          response(200, 'successful') do
            let(:playlist_shared_friend) do
              create(:playlist, :shared, user: create(:friendship, :accepted, user_to: user).user_from)
            end
            let(:id) { playlist_shared_friend.id }

            run_test! do
              expect(response.body).to match_response_schema(Api::Schemas::Playlist::SINGLE_SCHEMA)
            end
          end
        end

        context 'without access' do
          response(403, 'access denied') do
            let(:id) { create(:playlist, :personal).id }

            run_test!
          end

          response(403, 'access denied') do
            let(:id) { create(:playlist, :shared).id }

            run_test!
          end
        end
      end
    end
  end

  path '/api/v1/playlists' do
    get('general playlist') do
      parameter name: :sort_order,
                in: :query,
                schema: {
                  type: :string
                }
      parameter name: :sort_by,
                in: :query,
                description: 'Field to be sorted by',
                schema: {
                  type: :string
                }
      parameter name: :s,
                in: :query,
                description: 'Search parameter',
                schema: {
                  type: :string
                }
      parameter name: :page,
                in: :query,
                schema: {
                  type: :integer
                }
      parameter name: 'includes[]',
                in: :query,
                type: :array,
                collectionFormat: :multi,
                items: {
                  type: :string,
                  enum: Api::V1::Playlist::HomeSerializer.includes
                }
      consumes 'application/json'
      produces 'application/json'
      tags :playlists

      let(:sort_order) { '' }
      let(:sort_by) { '' }
      let(:s) { '' }
      let(:page) { 0 }
      let(:'includes[]') { Api::V1::Playlist::HomeSerializer.includes }
      let(:playlist) { create(:playlist_with_songs, :general, count: 1, likes_count: 1, dislikes_count: 1) }

      response(200, 'successful') do
        schema type: :object,
               '$ref': '#/definitions/public_playlists'

        run_test! do
          expect(response.body).to match_response_schema(Api::Schemas::Playlist::MANY_SCHEMA)
        end
      end

      before do
        playlist.update(deleted_at: Time.zone.now)
      end

      response(200, 'successful') do
        let(:data) { JSON.parse(response.body)['data'] }

        run_test! do
          expect(data.length).to eq(0)
        end
      end
    end

    post('create playlist') do
      consumes 'multipart/form-data'
      tags :playlists

      security [Bearer: []]
      parameter name: :title, in: :formData, type: :string, required: true
      parameter name: :description, in: :formData, type: :string, required: false
      parameter name: :visibility, in: :formData, type: :string, required: false
      parameter name: :logo, in: :formData, type: :file, required: false

      let(:user) { create(:user) }
      let(:Authorization) { authorization(user) }
      let(:title) { 'Title' }

      describe 'as guest' do
        let(:Authorization) { nil }

        response(401, 'unauthorized') do
          run_test!
        end
      end

      describe 'as user' do
        before do
          Sidekiq::Testing.inline!
        end

        response(201, 'created') do
          schema type: :object,
                 properties: {
                   message: { type: :string }
                 }

          let(:description) { 'new description' }
          let(:visibility) { 'general' }
          let(:logo) { fixture_file_upload('spec/fixtures/logo/test_logo.png') }

          run_test! do
            expect(response.body).to match_response_schema(Api::Schemas::Playlist::SINGLE_SCHEMA)
            expect(Playlist.count).to eq(1)
            expect(user.reload.playlists_created).to eq(1)
            allow(::Api::V1::Statistics::AchievementService).to receive(:call).with(user)
          end
        end

        response(400, 'bad request') do
          let(:description) { "Real lon#{'g' * Api::V1::Playlists::BaseForm::DESCRIPTION_MAX_LENGTH}" }
          let(:title) { 'T' }
          let(:logo) { fixture_file_upload('spec/fixtures/logo/favicon.ico') }

          run_test! do
            expect(Playlist.count).to eq(0)
          end
        end

        response(400, 'bad request') do
          schema type: :object,
                 properties: {
                   errors: { type: :object }
                 }
          let(:visibility) { 'availabile for Mark' }

          run_test! do
            expect(Playlist.count).to eq(0)
          end
        end
      end
    end
  end

  path '/api/v1/playlists/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    put('update playlist') do
      consumes 'multipart/form-data'
      produces 'application/json'

      tags :playlists

      security [Bearer: []]
      parameter name: :title, in: :formData, type: :string, required: false
      parameter name: :description, in: :formData, type: :string, required: false
      parameter name: :visibility, in: :formData, type: :string, required: false
      parameter name: :logo, in: :formData, type: :file, required: false

      let(:user) { create(:user) }
      let(:Authorization) { authorization(user) }

      let(:title) { 'Original title' }
      let(:description) { 'Obviously the best description ever written' }
      let(:logo) { fixture_file_upload('spec/fixtures/logo/test_logo.png') }

      let(:invalid_title) { 'e' }
      let(:invalid_description) { "Real lon#{'g' * Api::V1::Playlists::BaseForm::DESCRIPTION_MAX_LENGTH}" }
      let(:invalid_logo) { fixture_file_upload('spec/fixtures/logo/favicon.ico') }

      describe 'as guest' do
        let(:Authorization) { '' }
        let(:visibility) { 'public' }

        context 'with public playlist' do
          let(:id) { create(:playlist, :general).id }

          response(401, 'unauthorized') do
            run_test!
          end
        end

        context 'with private playlist' do
          let(:id) { create(:playlist, :personal).id }

          response(401, 'unauthorized') do
            run_test!
          end
        end

        context 'with shared playlist' do
          let(:id) { create(:playlist, :shared).id }

          response(401, 'access denied') do
            run_test!
          end
        end
      end

      context 'without any parameters' do
        let(:id) { create(:playlist, :general, user:).id }

        response(200, 'success') do
          run_test!
        end
      end

      describe 'as user' do
        before do
          Sidekiq::Testing.inline!
        end

        context 'with own public playlist' do
          let(:users_public_playlist) { create(:playlist, :general, user:) }
          let(:id) { users_public_playlist.id }
          let(:visibility) { 'personal' }

          response(200, 'success') do
            schema type: :object,
                   properties: {
                     message: { type: :string }
                   }

            run_test! do
              expect(response.body).to match_response_schema(Api::Schemas::Playlist::SINGLE_SCHEMA)
              expect(users_public_playlist.reload).to be_personal
              expect(users_public_playlist.title).to eq title
              expect(users_public_playlist.description).to eq description
              expect(users_public_playlist.logo).to exist
            end
          end

          response(400, 'bad request') do
            schema type: :object,
                   properties: {
                     errors: { type: :object }
                   }

            let(:title) { invalid_title }
            let(:description) { invalid_description }
            let(:logo) { invalid_logo }
            let(:original_attributes) { users_public_playlist.attributes }

            run_test! do
              expect(users_public_playlist.reload.attributes).to eq original_attributes
            end
          end
        end

        context 'with own personal playlist' do
          let(:users_personal_playlist) { create(:playlist, :personal, user:) }
          let(:id) { users_personal_playlist.id }
          let(:visibility) { 'general' }

          response(200, 'success') do
            run_test! do
              expect(response.body).to match_response_schema(Api::Schemas::Playlist::SINGLE_SCHEMA)
              expect(users_personal_playlist.reload).to be_general
              expect(users_personal_playlist.title).to eq title
              expect(users_personal_playlist.description).to eq description
              expect(users_personal_playlist.logo).to exist
            end
          end

          response(400, 'bad request') do
            let(:title) { invalid_title }
            let(:description) { invalid_description }
            let(:logo) { invalid_logo }
            let(:original_attributes) { users_personal_playlist.attributes }

            run_test! do
              expect(users_personal_playlist.reload.attributes).to eq original_attributes
            end
          end
        end

        context 'with own shared playlist' do
          let(:users_shared_playlist) { create(:playlist, :shared, user:) }
          let(:id) { users_shared_playlist.id }

          response(200, 'success') do
            run_test! do
              expect(response.body).to match_response_schema(Api::Schemas::Playlist::SINGLE_SCHEMA)
              expect(users_shared_playlist.reload.title).to eq title
              expect(users_shared_playlist.description).to eq description
              expect(users_shared_playlist.logo).to exist
            end
          end

          response(400, 'bad request') do
            let(:title) { invalid_title }
            let(:description) { invalid_description }
            let(:logo) { invalid_logo }
            let(:original_attributes) { users_shared_playlist.attributes }

            run_test! do
              expect(users_shared_playlist.attributes).to eq original_attributes
            end
          end
        end

        context 'with someones public playlist' do
          let(:id) { create(:playlist, :general).id }

          response(403, 'access denied') do
            run_test!
          end
        end

        context 'with someones private playlist' do
          let(:id) { create(:playlist, :personal).id }

          response(403, 'access denied') do
            run_test!
          end
        end

        context 'with someones shared playlist' do
          let(:id) { create(:playlist, :shared).id }

          response(403, 'access denied') do
            run_test!
          end
        end

        context 'with friends shared playlist' do
          let(:friends_shared) do
            create(:playlist, :shared, user: create(:friendship, :accepted, user_to: user).user_from)
          end
          let(:id) { friends_shared.id }

          response(403, 'access denied') do
            run_test!
          end
        end

        context 'with corrupted id' do
          let(:id) { FFaker::Lorem.word }

          response(404, 'record not found') do
            run_test!
          end
        end
      end

      describe 'can modify only one field' do
        let(:users_personal_playlist) { create(:playlist, :personal, user:) }
        let(:users_shared_playlist) { create(:playlist, :shared, user:) }
        let(:id) { users_shared_playlist.id }

        before do
          Sidekiq::Testing.inline!
        end

        context 'with title' do
          response(200, 'success') do
            run_test! do
              expect(users_shared_playlist.reload.title).to eq title
            end
          end

          response(400, 'bad request') do
            let(:title) { invalid_title }
            let(:original) { users_shared_playlist.title }

            run_test! do
              expect(users_shared_playlist.reload.title).to eq original
            end
          end
        end

        context 'with description' do
          response(200, 'success') do
            run_test! do
              expect(users_shared_playlist.reload.description).to eq description
            end
          end

          response(400, 'bad request') do
            let(:description) { invalid_description }
            let(:original) { users_shared_playlist.description }

            run_test! do
              expect(users_shared_playlist.reload.description).to eq original
            end
          end
        end

        context 'with logo' do
          response(200, 'success') do
            run_test! do
              expect(users_shared_playlist.reload.logo).to exist
            end
          end

          response(400, 'bad request') do
            let(:logo) { invalid_logo }

            run_test! do
              expect(users_shared_playlist.reload.logo).to be_nil
            end
          end
        end

        context 'with visibility for shared' do
          response(400, 'bad request') do
            let(:visibility) { 'personal' }

            run_test! do
              expect(users_shared_playlist.reload).to be_shared
            end
          end
        end

        context 'with visibility for others' do
          let(:id) { users_personal_playlist.id }

          response(200, 'success') do
            let(:visibility) { 'shared' }

            run_test! do
              expect(users_personal_playlist.reload).to be_shared
            end
          end

          response(400, 'bad request') do
            let(:visibility) { 'invalid visibility' }

            run_test! do
              expect(users_personal_playlist.reload).to be_personal
            end
          end
        end
      end
    end
  end

  path '/api/v1/playlists/{id}' do
    let(:user) { create(:user) }
    let(:Authorization) { authorization(user) }
    let(:id) { playlist.id }
    let(:playlist) { create(:playlist, user_id: user.id) }

    delete('delete playlist') do
      consumes 'application/json'
      produces 'application/json'
      tags :playlists

      security [Bearer: []]
      parameter name: :id, in: :path, type: :string, required: true
      response(204, 'no content') do
        run_test! do
          expect(Playlist.where(id:).first.deleted_at).not_to be_nil
        end
      end

      response(204, 'no content') do
        run_test! do
          expect(Playlist.where(id:)).to exist
        end
      end

      response(403, 'forbidden') do
        let(:playlist) { create(:playlist) }

        run_test!
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }

        run_test!
      end

      response(401, 'unauthorized') do
        let(:Authorization) { "#{authorization(user)}id" }

        run_test!
      end
    end
  end
end
