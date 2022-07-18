RSpec.describe SongsGenresQuery, type: :query do
  let(:top_genre) { create(:genre) }
  let(:top_song1) { create(:song, genre: top_genre, count_listening: 10) }
  let(:top_song2) { create(:song, genre: top_genre, count_listening: 15) }

  let(:top_songs) do
    [
      top_song2,
      top_song1
    ]
  end

  before do
    stub_const('SongsGenresQuery::SONGS_LIMIT', 2)

    other_genre = create(:genre)
    create(:song, genre: other_genre, count_listening: 9)
    create(:song, genre: top_genre, count_listening: 8)
  end

  it 'top song by genres' do
    result = described_class.call.limit(SongsGenresQuery::SONGS_LIMIT)
    expect(result).to match(top_songs)
  end
end
