RSpec.describe Statistic, type: :model do
  it { is_expected.to have_db_column(:new_users).of_type(:integer) }
  it { is_expected.to have_db_column(:new_deleted_users).of_type(:integer) }
  it { is_expected.to have_db_column(:new_playlists).of_type(:integer) }
  it { is_expected.to have_db_column(:new_deleted_playlists).of_type(:integer) }
  it { is_expected.to have_db_column(:new_playlist_songs).of_type(:integer) }
  it { is_expected.to have_db_column(:new_friendships).of_type(:integer) }
  it { is_expected.to have_db_column(:new_accepted_friendships).of_type(:integer) }
  it { is_expected.to have_db_column(:new_songs).of_type(:integer) }
  it { is_expected.to have_db_column(:new_genres).of_type(:integer) }
  it { is_expected.to have_db_column(:new_authors).of_type(:integer) }
  it { is_expected.to have_db_column(:total_users).of_type(:integer) }
  it { is_expected.to have_db_column(:total_deleted_users).of_type(:integer) }
  it { is_expected.to have_db_column(:total_playlists).of_type(:integer) }
  it { is_expected.to have_db_column(:total_songs).of_type(:integer) }
  it { is_expected.to have_db_column(:total_genres).of_type(:integer) }
  it { is_expected.to have_db_column(:total_authors).of_type(:integer) }
end
