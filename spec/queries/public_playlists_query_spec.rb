RSpec.describe PublicPlaylistsQuery, type: :query do
  describe 'sorting' do
    context 'with default sorting' do
      context 'when successful sorting' do
        let(:public_playlists) do
          [
            create(:playlist, :general, likes_count: 3, created_at: PopularPlaylistsQuery::CREATED.ago),
            create(:playlist, :general, likes_count: 3, created_at: (PopularPlaylistsQuery::CREATED + 1.hour).ago),
            create(:playlist, :general, dislikes_count: 4, created_at: PopularPlaylistsQuery::CREATED.ago),
            create(:playlist, :general, dislikes_count: 4, created_at: (PopularPlaylistsQuery::CREATED + 1.hour).ago)
          ]
        end

        it 'expect to return proper playlists' do
          result = described_class.call
          expect(result).to eq(public_playlists)
        end

        it 'expect to return reversed playlists' do
          result = described_class.call(sort_order: 'ASC')
          expect(result).to eq(public_playlists.reverse)
        end
      end

      context 'when playlists are not included' do
        let(:public_playlists) do
          [
            create(:playlist, :general, likes_count: 3, created_at: PopularPlaylistsQuery::CREATED.ago,
                                        deleted_at: Time.zone.now),
            create(:playlist, :general, user: create(:user, :inactive), likes_count: 3,
                                        created_at: (PopularPlaylistsQuery::CREATED + 1.hour).ago),
            create(:playlist, :general, dislikes_count: 4, created_at: PopularPlaylistsQuery::CREATED.ago),
            create(:playlist, :general, dislikes_count: 4, created_at: (PopularPlaylistsQuery::CREATED + 1.hour).ago)
          ]
        end

        let(:new_list) do
          [
            create(:playlist, :general, dislikes_count: 4, created_at: PopularPlaylistsQuery::CREATED.ago),
            create(:playlist, :general, dislikes_count: 4, created_at: (PopularPlaylistsQuery::CREATED + 1.hour).ago)
          ]
        end

        it 'expect inactive playlist not to be included' do
          expect(described_class.call).not_to include(public_playlists[0])
        end

        it 'expect playlist with inactive user not to be included' do
          expect(described_class.call).not_to include(public_playlists[1])
        end

        it 'expect to return proper playlists' do
          result = described_class.call
          expect(result).to eq(new_list)
        end

        it 'expect to return reversed playlists' do
          result = described_class.call(sort_order: 'ASC')
          expect(result).to eq(new_list.reverse)
        end
      end
    end

    context 'with title sorting' do
      let(:public_playlists) do
        [
          create(:playlist, :general, title: 'AD'),
          create(:playlist, :general, title: 'AC'),
          create(:playlist, :general, title: 'AB'),
          create(:playlist, :general, title: 'AA')
        ]
      end

      it 'expect to return proper playlists' do
        result = described_class.call(sort_by: 'title')
        expect(result).to eq(public_playlists)
      end

      it 'expect to return reversed playlists' do
        result = described_class.call(sort_by: 'title', sort_order: 'ASC')
        expect(result).to eq(public_playlists.reverse)
      end
    end

    context 'with comments_count sorting' do
      let(:public_playlists) do
        [
          create(:playlist, :general),
          create(:playlist, :general),
          create(:playlist, :general),
          create(:playlist, :general)
        ]
      end

      before do
        public_playlists.each_with_index do |playlist, index|
          (public_playlists.length - index - 1).times do
            create(:comment, playlist:, user: User.all.sample)
          end
        end
      end

      it 'expect to return proper playlists' do
        result = described_class.call(sort_by: 'comments_count')
        expect(result).to eq(public_playlists)
      end

      it 'expect to return reversed playlists' do
        result = described_class.call(sort_by: 'comments_count', sort_order: 'ASC')
        expect(result).to eq(public_playlists.reverse)
      end
    end
  end

  describe 'search' do
    context 'with one field' do
      let(:song_result) { create(:playlist, :general) }
      let!(:owner_nickname_result) { create(:playlist, :general, user: create(:user, username: 'search_user_search')) }
      let!(:title_result) { create(:playlist, :general, title: 'search title search') }
      let!(:description_result) { create(:playlist, :general, description: 'search description search') }

      before do
        create(:playlist_song, playlist: song_result,
                               song: create(:song,
                                            title: 'search song search',
                                            author: create(:author, nickname: 'search author search')))
      end

      context 'when successful search by song' do
        let(:result) { described_class.call(s: 'song') }

        it 'search by song title' do
          expect(result.first).to match(song_result)
        end
      end

      context 'when success searching by author' do
        let(:result) { described_class.call(s: 'author') }
        let!(:song_result) { create(:playlist, :general) }

        it 'search by song\'s author' do
          expect(result.first).to match(song_result)
        end
      end

      context 'when successful search by user' do
        let(:result) { described_class.call(s: 'user') }

        it 'search by owner\'s nickname' do
          expect(result.first).to match(owner_nickname_result)
        end
      end

      context 'when successful search by title' do
        let(:result) { described_class.call(s: 'title') }

        it 'search by title' do
          expect(result.first).to match(title_result)
        end
      end

      context 'when successful search by description' do
        let(:result) { described_class.call(s: 'description') }

        it 'search by description' do
          expect(result.first).to match(description_result)
        end
      end

      context 'when failed search by author' do
        let(:result) { described_class.call(s: 'author') }
        let(:song_result) do
          create(:playlist, :general, user: create(:user, :inactive), deleted_at: Time.zone.now)
        end

        it 'cant find by author due to inactive objects' do
          expect(result.first).not_to match(song_result)
        end
      end

      context 'when failed search by song' do
        let(:result) { described_class.call(s: 'song') }
        let(:song_result) do
          create(:playlist, :general, user: create(:user, :inactive), deleted_at: Time.zone.now)
        end

        it 'cant find by song title due to inactive objects' do
          expect(result.first).not_to match(song_result)
        end
      end

      context 'when failed search by user' do
        let(:result) { described_class.call(s: 'user') }
        let(:owner_nickname_result) do
          create(:playlist, :general, user: create(:user, :inactive, username: 'search_user_search'),
                                      deleted_at: Time.zone.now)
        end

        it 'cant find by owners nickname due to inactive objects' do
          expect(result.first).not_to match(owner_nickname_result)
        end
      end

      context 'when failed search by title' do
        let(:result) { described_class.call(s: 'title') }
        let!(:title_result) do
          create(:playlist, :general, user: create(:user, :inactive), title: 'search title search',
                                      deleted_at: Time.zone.now)
        end

        it 'cant find by title due to inactive objects' do
          expect(result.first).not_to match(title_result)
        end
      end

      context 'when failed search by description' do
        let(:result) { described_class.call(s: 'description') }
        let!(:description_result) do
          create(:playlist, :general, user: create(:user, :inactive), description: 'search description search',
                                      deleted_at: Time.zone.now)
        end

        it 'cant find by description due to inactive objects' do
          expect(result.first).not_to match(description_result)
        end
      end
    end

    context 'with all fields' do
      let(:playlists) do
        [
          create(:playlist, :general, title: 'AB'),
          create(:playlist, :general, title: 'BA'),
          create(:playlist, :general, title: 'CA', user: create(:user, username: 'search')),
          create(:playlist, :general, title: 'D search'),
          create(:playlist, :general, title: 'EA', description: 'search')
        ]
      end
      let(:result) { described_class.call(s: :search, sort_order: 'ASC', sort_by: 'title') }

      before do
        create(:playlist_song, playlist: playlists[0], song: create(:song, title: 'search'))
        create(:playlist_song, playlist: playlists[1],
                               song: create(:song, author: create(:author, nickname: 'search')))
        wrong_playlist = create(:playlist, :general, title: 'AA', description: 'wrong desc',
                                                     user: create(:user, username: 'wrong_name'))
        create(:playlist_song, playlist: wrong_playlist,
                               song: create(:song, title: 'wrong title',
                                                   author: create(:author, nickname: 'wrong name')))
      end

      context 'when returns proper playlists' do
        it 'returns proper playlists' do
          expect(result).to eq(playlists)
        end
      end

      context 'when doesnt return playlists with inactive properties' do
        let(:playlists) do
          [
            create(:playlist, :general, title: 'AB'),
            create(:playlist, :general, title: 'BA'),
            create(:playlist, :general, title: 'CA', user: create(:user, username: 'search'),
                                        deleted_at: Time.zone.now),
            create(:playlist, :general, title: 'D search', user: create(:user, :inactive)),
            create(:playlist, :general, title: 'EA', description: 'search')
          ]
        end

        it 'doesnt return inactive playlist' do
          expect(result).not_to include(playlists[2])
        end

        it 'doesnt return playlist with inactive user' do
          expect(result).not_to include(playlists[3])
        end
      end
    end
  end
end
