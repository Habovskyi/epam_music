RSpec.describe Api::V1::Friendships::CreateForm, type: :model do
  subject(:friendship) { described_class.new(build(:friendship)) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user_from_id) }
  end

  describe 'invitation pair' do
    before do
      friendship.save
    end

    context 'when user invite himself' do
      let(:user) { create(:user) }

      it 'do not allow user to make self invitation' do
        expect(friendship.validate(user_from_id: user.id, user_to_id: user.id)).to be false
      end
    end

    context 'when invitation duplicates' do
      let(:duplicate_invited) { described_class.new(::Friendship.new) }

      it 'do not allow duplicates' do
        expect(duplicate_invited.validate(user_from_id: friendship.user_from_id,
                                          user_to_id: friendship.user_to_id)).to be false
      end
    end

    context 'with reverse invitation' do
      let(:reverse_invited) { described_class.new(::Friendship.new) }

      it 'do not allow to send reverse invitation' do
        expect(reverse_invited.validate(user_from_id: friendship.user_to_id,
                                        user_to_id: friendship.user_from_id)).to be false
      end
    end
  end
end
