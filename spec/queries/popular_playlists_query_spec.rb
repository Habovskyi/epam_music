RSpec.describe PopularPlaylistsQuery, type: :query do
  let!(:popular_playlist) do
    create(:playlist_with_songs, :general, title: 'ritth', count: 6, likes_count: 2, dislikes_count: 1,
                                           created_at: PopularPlaylistsQuery::CREATED.ago)
  end

  before do
    create(:playlist, :general, created_at: PopularPlaylistsQuery::CREATED.ago)
    create(:playlist, :general, likes_count: 3, created_at: PopularPlaylistsQuery::CREATED.ago)
    create(:playlist_with_songs, :general, count: 6)
    create(:playlist_with_songs, :personal, count: 6, created_at: PopularPlaylistsQuery::CREATED.ago)
    create(:playlist_with_songs, :general, count: 6, likes_count: 1, dislikes_count: 3,
                                           created_at: PopularPlaylistsQuery::CREATED.ago)
    create(:playlist_with_songs, :general, count: 6, dislikes_count: 4, created_at: PopularPlaylistsQuery::CREATED.ago)
  end

  it 'expect to return proper playlists' do
    result = described_class.call
    expect(result.first).to match(popular_playlist)
  end

  context 'when user inactive expect popular playlist to stop being in the list' do
    before do
      popular_playlist.user.update(active: false)
    end

    it 'expect not being included in the list' do
      expect(described_class.call).not_to include(popular_playlist)
    end

    it 'expect not matching the first playlist' do
      expect(described_class.call.first).not_to match(popular_playlist)
    end
  end

  context 'when playlist inactive expect popular playlist to stop being in the list' do
    before do
      popular_playlist.update(deleted_at: Time.zone.now)
    end

    it 'expect not being included in the list' do
      expect(described_class.call).not_to include(popular_playlist)
    end

    it 'expect not matching the first playlist' do
      expect(described_class.call.first).not_to match(popular_playlist)
    end
  end

  context 'when playlist and user inactive expect popular playlist to stop being in the list' do
    before do
      popular_playlist.update(deleted_at: Time.zone.now)
      popular_playlist.user.update(active: false)
    end

    it 'expect not being included in the list' do
      expect(described_class.call).not_to include(popular_playlist)
    end

    it 'expect not matching the first playlist' do
      expect(described_class.call.first).not_to match(popular_playlist)
    end
  end
end
