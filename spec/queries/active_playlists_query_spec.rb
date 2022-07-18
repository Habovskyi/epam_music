RSpec.describe ActivePlaylistsQuery, type: :query do
  let(:active_user) { create(:user) }
  let(:inactive_user) { create(:user, :inactive) }

  context 'when active playlist and user' do
    let!(:valid_playlist) { create(:playlist, user: active_user) }

    it 'included in playlists list' do
      expect(described_class.call).to include(valid_playlist)
    end
  end

  context 'when with active user and inactive playlist' do
    let!(:playlist_with_active_user) { create(:playlist, user: active_user, deleted_at: Time.zone.yesterday) }

    it 'not included in playlists list' do
      expect(described_class.call).not_to include(playlist_with_active_user)
    end
  end

  context 'when with inactive user with active playlist' do
    let!(:playlist_with_inactive_user) { create(:playlist, user: inactive_user) }

    it 'not included in playlists list' do
      expect(described_class.call).not_to include(playlist_with_inactive_user)
    end
  end

  context 'when with inactive both playlist and user' do
    let!(:totally_invalid_playlist) { create(:playlist, user: inactive_user, deleted_at: Time.zone.yesterday) }

    it 'not included in playlists list' do
      expect(described_class.call).not_to include(totally_invalid_playlist)
    end
  end
end
