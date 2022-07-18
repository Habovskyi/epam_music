RSpec.describe MostFriendlyUsersQuery, type: :query do
  let(:users) { create_list(:user, 5, :user_with_predefined_emails) }
  let(:most_friendly) { [users[2], users[1], users[3], users[0], users[4]] }

  before do
    [[0, 2], [1, 2], [2, 3], [3, 1], [4, 2]].each do |(from, to)|
      create(:accepted_friendship, user_from: users[from], user_to: users[to])
    end
  end

  it 'expect to return proper users' do
    expect(described_class.call).to match(most_friendly)
  end

  context 'when most friendly user is not active' do
    before do
      users[2].update(active: false)
    end

    let!(:most_friendly) { [users[1], users[3], users[0], users[4]] }

    it 'expect not to include invalid user' do
      expect(described_class.call).not_to include(users[2])
    end

    it 'expect to match users' do
      expect(described_class.call).to match(most_friendly)
    end
  end
end
