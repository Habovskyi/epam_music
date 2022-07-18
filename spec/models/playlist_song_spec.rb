RSpec.describe PlaylistSong, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:playlist) }
    it { is_expected.to belong_to(:song) }
  end

  describe 'fields' do
    it { is_expected.to have_db_column(:id).of_type(:uuid) }
    it { is_expected.to have_db_column(:user_id).of_type(:uuid) }
    it { is_expected.to have_db_column(:playlist_id).of_type(:uuid) }
    it { is_expected.to have_db_column(:song_id).of_type(:uuid) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
  end
end
