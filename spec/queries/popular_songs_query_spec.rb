RSpec.describe PopularSongsQuery, type: :query do
  let(:popular_song1) { create(:song) }
  let(:popular_song2) { create(:song) }

  let(:popular_songs) do
    [
      popular_song2,
      popular_song1
    ]
  end

  before do
    stub_const('PopularPlaylistsQuery::SONGS_LIMIT', 2)

    create(:playlist).playlist_songs.create(song: popular_song2)
    create(:playlist).playlist_songs.create(song: popular_song2)
    create(:playlist).playlist_songs.create(song: popular_song2)
    create(:playlist).playlist_songs.create(song: popular_song2)
    create(:playlist).playlist_songs.create(song: popular_song1)
    create(:playlist).playlist_songs.create(song: popular_song1)
    create(:playlist).playlist_songs.create(song: create(:song))
  end

  it 'popular song' do
    result = described_class.call.limit(PopularPlaylistsQuery::SONGS_LIMIT)
    expect(result).to match(popular_songs)
  end
end
