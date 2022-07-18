RSpec.describe Api::V1::Statistics::GenerateService, type: :service do
  subject(:result) { described_class.call(statistic_period)[0] }

  let(:statistic_period) { 24.hours }
  let(:expected_result) do
    {
      new_users: 3,
      new_playlists: 1,
      new_playlist_songs: 1,
      new_friendships: 2,
      new_accepted_friendships: 1,
      new_songs: 1,
      new_genres: 1,
      new_authors: 1,
      new_deleted_users: 1,
      new_deleted_playlists: 1,
      total_users: 4,
      total_deleted_users: 1,
      total_playlists: 2,
      total_songs: 2,
      total_genres: 2,
      total_authors: 2
    }
  end

  before do
    old_user = create(:user, created_at: (statistic_period + 1.minute).ago) # +1 user
    create(:playlist, user: old_user, created_at: (statistic_period + 1.minute).ago) # +1 playlists
    old_genre = create(:genre, created_at: (statistic_period + 1.minute).ago) # +1 genre
    old_author = create(:author, created_at: (statistic_period + 1.minute).ago) # +1 author
    create(:song, author: old_author, genre: old_genre, created_at: (statistic_period + 1.minute).ago) # +1 song
    described_class.call # intial statistic

    new_user = create(:user) # +1 new_user
    new_playlist = create(:playlist, user: new_user) # +1 new_playlist
    create(:playlist_song, playlist: new_playlist, user: new_user,
                           song: create(:song, author: create(:author), genre: create(:genre)))
    # +1 new_song, +1 new_playlist_song +1 new_genre, +1 new_author
    create(:friendship, user_to: new_user) # +1 new_friendship, +1 new_user
    create(:friendship, :accepted, user_from: new_user) # +1 new_friendship, +1 new_user, +1 new_accepted friendships
    deleted_user = create(:user)
    deleted_user.update(active: false) # +1 new_deleted_users
    deleted_playlist = create(:playlist, user: new_user)
    deleted_playlist.update(deleted_at: Time.zone.now) # +1 new_deleted_playlists
    result
  end

  it 'save statistic' do
    expect(::Statistic.count).to eq(2)
  end

  it 'count propperly' do
    expect(::Statistic.order(:created_at).last).to have_attributes(expected_result)
  end
end
