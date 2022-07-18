RSpec.describe Api::V1::Users::Playlists::Index, type: :service do
  subject(:result) { described_class.call(current_user:, params:) }

  let(:current_user) { create(:user) }
  let(:params) { { page: nil, type: } }
  let!(:shared_playlist) do
    create(:playlist, :shared, user: create(:friendship, :accepted, user_from: current_user).user_to)
  end
  let!(:owned_playlist) { create(:playlist, :shared, user: current_user) }

  before do
    create(:playlist, :personal, user: create(:friendship, :accepted, user_from: current_user).user_to)
    create(:playlist, :general, user: create(:friendship, :accepted, user_from: current_user).user_to)
    create(:playlist, :general)
    create(:playlist, :personal)
    create(:playlist, :shared, deleted_at: Time.zone.now,
                               user: create(:friendship, :accepted, user_from: current_user).user_to)
    create(:playlist, :shared, deleted_at: Time.zone.now, user: current_user)
  end

  context 'with `shared` type' do
    let(:type) { 'shared' }

    it 'succeeds' do
      expect(result).to be_success
    end

    it 'returns my friends active shared playlist' do
      expect(result[:model]).to contain_exactly(shared_playlist)
    end
  end

  context 'without type' do
    let(:type) { nil }

    it 'succeeds' do
      expect(result).to be_success
    end

    it 'returns my active playlist' do
      expect(result[:model]).to contain_exactly(owned_playlist)
    end
  end
end
