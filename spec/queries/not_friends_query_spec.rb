RSpec.describe NotFriendsQuery, type: :query do
  let(:user) { create(:user) }
  let(:existing_user) { create(:user) }

  let(:not_friends) do
    create_list(:friendship, 2, :declined, user_from: user).map(&:user_to)
  end

  let(:friend) do
    [create(:friendship, :accepted, user_from: user, user_to: existing_user)]
  end

  it 'expect to return proper users' do
    expect(described_class.call(user)).to match(not_friends)
  end

  it 'expect to not return proper users' do
    expect(described_class.call(user)).not_to match(friend)
  end

  context 'when not active users are not shown in the list' do
    before do
      not_friends.map { |user| user.update(active: false) }
    end

    it 'expect to stop show inactive people in the list' do
      expect(described_class.call(user)).not_to match(not_friends)
    end
  end
end
