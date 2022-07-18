RSpec.describe FriendsQuery, type: :query do
  let(:user) { create(:user) }

  let(:friends) do
    create_list(:friendship, 2, :accepted, user_from: user).map(&:user_to)
  end

  let(:not_friends) do
    create_list(:friendship, 2, :declined, user_from: user).map(&:user_to)
  end

  it 'expect to return proper users' do
    expect(described_class.call(user)).to match(friends)
  end

  it 'expect to not return proper users' do
    expect(described_class.call(user)).not_to match(not_friends)
  end

  context 'when inactive users are not in the list of friends' do
    before do
      friends.map { |friend| friend.update(active: false) }
    end

    it 'expect friends stop being in the friends list' do
      expect(described_class.call(user)).not_to match(friends)
    end
  end
end
