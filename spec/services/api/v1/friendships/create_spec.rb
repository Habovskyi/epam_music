RSpec.describe Api::V1::Friendships::Create, type: :service do
  subject(:result) { described_class.call(current_user:, params:) }

  let(:params) { { user_to_id: friend.id } }
  let(:current_user) { create(:user) }
  let(:friend) { create(:user) }

  describe 'succeeds' do
    before do
      result
    end

    it 'creates model' do
      expect(::Friendship.count).to eq(1)
    end

    it 'assings invitation to two users' do
      current_user.reload
      friend.reload
      expect(current_user.friendship_from).to match(friend.friendship_to)
    end

    it 'create pending relationship' do
      expect(::Friendship.last).to be_pending
    end
  end

  describe 'failure' do
    before do
      result
    end

    context 'with not present user' do
      let(:friend) { build(:user) }

      it "doesn't save model" do
        expect(::Friendship.count).to eq(0)
      end

      it 'fill errors' do
        expect(result.errors).not_to be_empty
      end
    end

    context 'with self invitation' do
      let(:friend) { current_user }

      it "doesn't save model" do
        expect(::Friendship.count).to eq(0)
      end

      it 'fill errors' do
        expect(result.errors).not_to be_empty
      end
    end
  end
end
