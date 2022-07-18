RSpec.describe Api::V1::Comments::Index, type: :service do
  subject(:result) { described_class.call(params:, current_user:) }

  let(:params) { ActionController::Parameters.new(playlist_id:, page: 1) }
  let(:playlist_id) { create(:playlist, :general, user: current_user).id }
  let(:current_user) { create(:user) }

  before do
    result
  end

  context 'when render result' do
    let!(:comment) { create(:comment, playlist_id:, user: current_user) }
    let(:serializer) { Api::V1::Comment::InfoSerializer }

    it 'shows right id' do
      expect(result[:model].first.id).to match(serializer.new(comment).to_hash[:data][:id])
    end

    it 'shows right content' do
      expect(result[:model].first.text).to match(serializer.new(comment).to_hash[:data][:attributes][:text])
    end
  end

  context 'when paginated' do
    let!(:comments) { create_list(:comment, 35, playlist_id:, user: current_user) }

    it 'expect to render comment' do
      expect(result[:model]).to include(comments[15])
    end

    it 'expect not to render comment' do
      expect(result[:model]).not_to include(comments[30])
    end
  end
end
