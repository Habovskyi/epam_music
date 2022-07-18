RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:playlists) }
    it { is_expected.to have_many(:playlist_songs).dependent(:destroy) }
  end

  describe 'fields' do
    it { is_expected.to have_db_column(:id).of_type(:uuid) }
    it { is_expected.to have_db_column(:email).of_type(:string) }
    it { is_expected.to have_db_column(:username).of_type(:string) }
    it { is_expected.to have_db_column(:password_digest).of_type(:string) }
    it { is_expected.to have_db_column(:first_name).of_type(:string) }
    it { is_expected.to have_db_column(:last_name).of_type(:string) }
    it { is_expected.to have_db_column(:playlists_created).of_type(:integer) }
    it { is_expected.to have_db_column(:active).of_type(:boolean) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }

    it { is_expected.to have_many(:friendship_from).with_foreign_key(:user_from_id) }
    it { is_expected.to have_many(:friendship_to).with_foreign_key(:user_to_id) }
  end

  describe 'best_contributors scope' do
    let!(:best_contributors) do
      [
        create(:user, playlists_created: 9),
        create(:user, playlists_created: 7),
        create(:user, playlists_created: 6),
        create(:user, playlists_created: 4),
        create(:user, playlists_created: 3)
      ]
    end

    before do
      create(:user, playlists_created: 2)
      create(:user, playlists_created: 1)
    end

    it 'expect to return proper users' do
      expect(described_class.best_contributors).to match(best_contributors)
    end

    it 'expect to fail due to wrong users order' do
      expect(described_class.best_contributors).not_to match(best_contributors.shuffle)
    end
  end

  describe '#friends' do
    let(:user) { create(:user) }
    let(:friend) { create(:user) }

    before { create(:accepted_friendship, user_to: user, user_from: friend) }

    context 'when active friend' do
      it 'expect friend to be included' do
        expect(user.friends).to include(friend)
      end
    end

    context 'when inactive friend' do
      it 'expect friend not to be included' do
        expect(user.friends).not_to include(friend.update(active: false))
      end
    end
  end

  describe '.active' do
    let(:inactive_user) { create(:user, :inactive) }
    let(:active_user) { create(:user) }

    context 'when active user' do
      it 'expect user to be included' do
        expect(described_class.active).to include(active_user)
      end
    end

    context 'when inactive user' do
      it 'expect user not to be included' do
        expect(described_class.active).not_to include(inactive_user)
      end
    end
  end

  describe '#shared_playlists' do
    let(:user) { create(:user) }
    let(:friend) { create(:user) }
    let(:friend_playlist) { create(:playlist, user: friend, visibility: 2) }

    before { create(:accepted_friendship, user_to: user, user_from: friend) }

    context 'when active playlist' do
      it 'includes in shared playlists list' do
        expect(user.shared_playlists).to include(friend_playlist)
      end
    end

    context 'when inactive playlist' do
      it 'isnt included in shared playlists list' do
        expect(user.shared_playlists).not_to include(friend_playlist.update(deleted_at: Time.zone.now))
      end
    end
  end

  describe '#user_and_shared_playlists' do
    let(:user) { create(:user) }
    let(:friend) { create(:user) }
    let(:user_playlist) { create(:playlist, user:) }
    let(:friend_playlist) { create(:playlist, user: friend, visibility: 2) }

    before { create(:accepted_friendship, user_to: user, user_from: friend) }

    context 'when active playlists' do
      it 'includes user playlist' do
        expect(user.user_and_shared_playlists).to include(user_playlist)
      end

      it 'includes friend playlist' do
        expect(user.user_and_shared_playlists).to include(friend_playlist)
      end
    end

    context 'when inactive playlists' do
      it 'isnt included user playlists' do
        expect(user.user_and_shared_playlists).not_to include(user_playlist.update(deleted_at: Time.zone.now))
      end

      it 'isnt included friend playlists' do
        expect(user.user_and_shared_playlists).not_to include(friend_playlist.update(deleted_at: Time.zone.now))
      end
    end
  end

  describe 'search' do
    context 'with search by email' do
      let!(:current_user) { create(:user) }
      let!(:email) { 'test@example.com' }
      let!(:expected_user) { create(:user, email: email.to_s) }

      before do
        create(:user, email: 'random@example.com')
      end

      it 'search and return propper result' do
        expect(current_user.not_friends.search(email).first).to match(expected_user)
      end
    end

    context 'with search already existing user in friends' do
      let!(:current_user) { create(:user) }
      let!(:email) { 'test@example.com' }
      let!(:expected_user) { create(:user, email: email.to_s) }

      before do
        create(:user, email: 'random@example.com')
        create(:friendship, :accepted, user_from: current_user, user_to: expected_user)
      end

      it 'search and return propper result' do
        expect(current_user.not_friends.search(email).first).not_to match(expected_user)
      end
    end

    context 'with search inactive and active users' do
      let!(:current_user) { create(:user) }
      let!(:active_email) { 'test@example.com' }
      let!(:inactive_user_email) { 'testsecond@example.com' }
      let!(:active_user) { create(:user, email: active_email.to_s) }
      let!(:inactive_user) { create(:user, :inactive, email: inactive_user_email.to_s) }

      it 'search and find user' do
        expect(current_user.not_friends.search(active_email).first).to match(active_user)
      end

      it 'search and dont find user' do
        expect(current_user.not_friends.search(inactive_user_email).first).not_to match(inactive_user)
      end
    end
  end
end
