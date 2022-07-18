RSpec.describe Api::V1::Comments::Create, type: :service do
  subject(:result) { described_class.call(params:, current_user:) }

  let(:params) { ActionController::Parameters.new(playlist_id:, text:) }
  let!(:current_user) { create(:user) }
  let(:text) { 'My comment' }
  let(:playlist_id) { create(:playlist, :general, user: current_user).id }

  before do
    result
  end

  describe 'succeeds' do
    it 'creates model' do
      expect(::Comment.count).to eq(1)
    end

    it 'assings invitation to two users' do
      current_user.reload
      expect(current_user.comments.first.text).to eq(text)
    end
  end

  describe 'failure' do
    context 'with invalid params' do
      let(:text) { "#{'a' * Api::V1::Comments::CreateForm::TEXT_MAX_LENGTH}a'" }

      it "doesn't save model" do
        expect(::Comment.count).to eq(0)
      end

      it 'fill errors' do
        expect(result.errors).not_to be_empty
      end
    end
  end
end
