RSpec.describe Playlist, type: :model do
  let(:user) { create(:user) }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:playlist_songs).dependent(:destroy) }
  end

  describe 'fields' do
    it { is_expected.to have_db_column(:id).of_type(:uuid) }
    it { is_expected.to have_db_column(:user_id).of_type(:uuid) }
    it { is_expected.to have_db_column(:title).of_type(:string) }
    it { is_expected.to have_db_column(:logo_data).of_type(:text) }
    it { is_expected.to have_db_column(:visibility).of_type(:integer) }
    it { is_expected.to have_db_column(:featured).of_type(:boolean) }
    it { is_expected.to have_db_column(:description).of_type(:text) }
    it { is_expected.to have_db_column(:deleted_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
  end

  describe '.featured' do
    let(:featured) { create(:playlist, :featured, user:) }
    let(:not_featured) { create(:playlist, :not_featured, user:) }

    it 'includes featured' do
      expect(described_class.featured).to include(featured)
    end

    it 'excludes featured' do
      expect(described_class.featured).not_to include(not_featured)
    end

    context 'with multiple playlists' do
      let!(:playlists_list) { create_list(:playlist, Playlist::HOME_QUERY_LIMIT + 1, :featured, user:) }

      it 'limit max quantity' do
        expect(described_class.featured.count).to eq(playlists_list.count - 1)
      end
    end
  end

  describe '.latest_added' do
    let(:public_playlist) { create(:playlist, :general, user:) }
    let(:private_playlist) { create(:playlist, :personal, user:) }

    it 'includes public' do
      expect(described_class.latest_added).to include(public_playlist)
    end

    it 'excludes private' do
      expect(described_class.latest_added).not_to include(private_playlist)
    end

    context 'with multiple playlists' do
      let!(:playlists_list) { create_list(:playlist, Playlist::HOME_QUERY_LIMIT + 1, :general, user:) }

      it 'limit max quantity' do
        expect(described_class.latest_added.count).to eq(playlists_list.count - 1)
      end
    end

    context 'when right order' do
      let!(:older_playlist) { create(:playlist, :general, user:) }
      let!(:newest_playlist) { create(:playlist, :general, user:) }

      it 'has playlist in the right order' do
        expect(described_class.latest_added.to_a).to eq([newest_playlist, older_playlist])
      end
    end
  end
end
