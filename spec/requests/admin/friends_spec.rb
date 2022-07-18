describe 'admin/friends', type: :request do
  let(:user) { create(:admin_user) }
  let!(:friend) { create(:friendship) }
  let!(:friend2) { create(:friendship) }
  let(:page) { Nokogiri::HTML.parse(response.body).text }

  before { sign_in user }

  describe 'Index' do
    before { get admin_friendships_path }

    it 'shows correct data' do
      expect(response).to be_truthy
      expect(page).to include(friend.user_from.username)
      expect(page).to include(friend2.user_to.username)
    end
  end

  describe 'Show' do
    before { get admin_friendship_path(friend) }

    it 'shows' do
      expect(page).to include(friend.user_from.username)
    end
  end
end
