RSpec.describe 'api/v1/home', type: :request do
  path '/api/v1/home_users' do
    parameter name: :type, in: :query, type: :enum, description: 'type', schema: {
      type: :string, enum: %i[most_friendly best_contributors]
    }

    # rubocop:disable RSpec/ScatteredSetup
    before { Flipper.enable :users_info_endpoint }
    # rubocop:enable RSpec/ScatteredSetup

    get('users_info home') do
      tags :home
      response(200, 'successful') do
        schema type: :object, '$ref': '#/definitions/home_users'
        let(:type) { 'best_contributors' }
        run_test!
      end

      response(400, 'bad request') do
        let(:type) { 'wrong_type' }
        run_test!
      end

      context 'when active and inactive best contributors' do
        response(200, 'successful') do
          let(:page) { Nokogiri::HTML.parse(response.body).text }
          let!(:active_best_contributor) { create(:user, :best_contributor) }
          let!(:inactive_best_contributor) { create(:user, :inactive, :best_contributor) }

          let(:type) { 'best_contributors' }

          run_test! do
            parsed_body = JSON.parse(response.body)
            expect(parsed_body['data'].length).to eq 1
            expect(parsed_body['data'].first['id']).to eq active_best_contributor.id
            expect(page).to include(active_best_contributor.username)
            expect(page).not_to include(inactive_best_contributor.username)
          end
        end
      end

      context 'when feature toogled as false' do
        before { Flipper.disable :users_info_endpoint }

        response(400, 'bad_request') do
          let(:type) { 'best_contributors' }

          run_test!
        end
      end
    end
  end

  path '/api/v1/home_playlists' do
    parameter name: :type, in: :query, type: :enum, description: 'type', schema: {
      type: :string, enum: %i[featured latest_added popular]
    }

    # rubocop:disable RSpec/ScatteredSetup
    before { Flipper.enable :playlists_info_endpoint }
    # rubocop:enable RSpec/ScatteredSetup

    get('playlists_info home') do
      tags :home
      response(200, 'successful') do
        schema type: :object, '$ref': '#/definitions/home_playlists'
        let(:type) { 'popular' }
        run_test! do
          expect(response.body).to match_response_schema(Api::Schemas::Playlist::MANY_SCHEMA)
        end
      end

      response(400, 'bad request') do
        let(:type) { 'wrong_type' }
        run_test!
      end

      context 'when active and inactive popular playlists' do
        response(200, 'successful') do
          let(:page) { Nokogiri::HTML.parse(response.body).text }
          let!(:valid_playlist) { create(:playlist, :popular) }
          let!(:invalid_playlist) { create(:playlist, :popular, deleted_at: Time.zone.now) }
          let(:type) { 'popular' }

          run_test! do
            parsed_body = JSON.parse(response.body)
            expect(parsed_body['data'].length).to eq 1
            expect(parsed_body['data'].first['id']).to eq valid_playlist.id
            expect(page).to include(valid_playlist.title)
            expect(page).not_to include(invalid_playlist.title)
          end
        end
      end

      context 'when active and inactive featured playlists' do
        response(200, 'successful') do
          let(:page) { Nokogiri::HTML.parse(response.body).text }
          let!(:valid_playlist) { create(:playlist, :featured) }
          let!(:invalid_playlist) { create(:playlist, :featured, deleted_at: Time.zone.now) }
          let(:type) { 'featured' }

          run_test! do
            parsed_body = JSON.parse(response.body)
            expect(parsed_body['data'].length).to eq 1
            expect(parsed_body['data'].first['id']).to eq valid_playlist.id
            expect(page).to include(valid_playlist.title)
            expect(page).not_to include(invalid_playlist.title)
          end
        end
      end

      context 'when active and inactive latest_added playlists' do
        response(200, 'successful') do
          let(:page) { Nokogiri::HTML.parse(response.body).text }
          let!(:valid_playlist_first) { create(:playlist, :general, created_at: Time.zone.now) }
          let!(:valid_playlist_second) { create(:playlist, :general, created_at: 10.minutes.ago) }
          let!(:invalid_playlist) { create(:playlist, :general, deleted_at: Time.zone.now) }
          let(:type) { 'latest' }

          run_test! do
            parsed_body = JSON.parse(response.body)
            expect(parsed_body['data'].length).to eq 2
            expect(parsed_body['data'].first['id']).to eq valid_playlist_first.id
            expect(parsed_body['data'].second['id']).to eq valid_playlist_second.id
            expect(page).to include(valid_playlist_first.title)
            expect(page).to include(valid_playlist_second.title)
            expect(page).not_to include(invalid_playlist.title)
          end
        end
      end

      context 'when feature toogled as false' do
        before { Flipper.disable :playlists_info_endpoint }

        response(400, 'bad_request') do
          let(:type) { 'best_contributors' }

          run_test!
        end
      end
    end
  end

  path '/api/v1/songs/{type}' do
    parameter name: 'type', in: :path, type: :string, description: 'type'

    # rubocop:disable RSpec/ScatteredSetup
    before { Flipper.enable :songs_endpoint }
    # rubocop:enable RSpec/ScatteredSetup

    get('songs home') do
      tags :songs
      response(200, 'successful') do
        schema type: :object,
               anyOf: [{ '$ref': '#/definitions/home_song' }, {}]

        let(:type) { 'popular' }
        run_test!
      end

      response(400, 'bad request') do
        let(:type) { 'abc' }
        run_test!
      end

      context 'when feature toogled as false' do
        before { Flipper.disable :songs_endpoint }

        response(400, 'bad_request') do
          let(:type) { 'popular' }
          run_test!
        end
      end
    end
  end
end
