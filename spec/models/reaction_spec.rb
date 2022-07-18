RSpec.describe Reaction, type: :model do
  subject(:reaction) { create(:reaction, user:, playlist:) }

  let(:user) { create(:user) }
  let(:playlist) { create(:playlist, user:) }

  describe 'fields' do
    it { is_expected.to have_db_column(:id).of_type(:uuid) }
    it { is_expected.to have_db_column(:user_id).of_type(:uuid) }
    it { is_expected.to have_db_column(:playlist_id).of_type(:uuid) }
    it { is_expected.to have_db_column(:reaction_type).of_type(:integer) }
    it { is_expected.to define_enum_for(:reaction_type).with_values(%i[liked disliked]) }

    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:playlist) }
  end

  describe 'validations' do
    context 'when create multiple reactions' do
      let(:reaction_copy) do
        build(:reaction, user: reaction.user, playlist: reaction.playlist,
                         reaction_type: reaction.reaction_type)
      end

      it 'is expected invalid multiple reaction' do
        expect(reaction_copy).not_to be_valid
      end
    end

    context 'when update reaction' do
      let!(:reaction) { create(:reaction, :disliked, user:, playlist:) }

      let!(:playlist_second) { create(:playlist, user:) }
      let!(:reaction_second) { create(:reaction, :disliked, user:, playlist: playlist_second) }

      it 'is expected successful update' do
        expect(reaction.update(reaction_type: 'liked')).to be_truthy
      end

      it 'is expected unsuccessful update' do
        expect(reaction_second.update(user:, playlist:)).not_to be_truthy
      end

      it 'is expected to be liked' do
        reaction.liked!
        expect(reaction.liked?).to be(true)
      end

      it 'is expected not to be disliked' do
        reaction.liked!
        expect(reaction.disliked?).not_to be(true)
      end
    end

    context 'when check reaction types' do
      it 'is expected liked reaction exists' do
        expect(described_class.reaction_types[:liked]).to be_truthy
      end

      it 'is expected disliked reaction exists' do
        expect(described_class.reaction_types[:disliked]).to be_truthy
      end

      it "is expected default doesn't exist" do
        expect(described_class.reaction_types[:default]).to be_falsey
      end
    end
  end
end
