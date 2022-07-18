RSpec.describe Api::V1::Reactions::CreateService, type: :service do
  subject(:result) { described_class.call(current_user, params) }

  let(:params) { { reaction_type:, playlist_id: } }
  let!(:current_user) { create(:user) }
  let!(:playlist_id) { create(:playlist, user: current_user).id }
  let(:reaction_type) { 'liked' }

  describe 'succeeds' do
    context 'when new reaction' do
      before { result }

      it 'creates model' do
        expect(::Reaction.count).to eq(1)
      end

      it 'has exactly passed reaction type' do
        expect(current_user.reactions.first.reaction_type).to eq(reaction_type)
      end
    end

    context 'when have previous reaction' do
      before do
        create(:reaction, :liked, user: current_user, playlist_id:)
        result
      end

      context 'when liked' do
        it 'remove previous reaction' do
          expect(current_user.reactions).to eq([])
        end
      end

      context 'when disliked' do
        let(:reaction_type) { 'disliked' }

        it 'remove previous create new one with opposite reaction type' do
          expect(current_user.reactions.first.reaction_type).to eq('disliked')
        end
      end
    end
  end
end
