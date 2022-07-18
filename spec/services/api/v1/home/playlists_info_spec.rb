RSpec.describe Api::V1::Home::PlaylistsInfo, type: :service do
  subject(:result) { described_class.call(type:) }

  let(:type) { 'invalid' }

  before do
    Flipper.enable(:playlists_info_endpoint)
  end

  context 'with invalid type' do
    it 'return bad request' do
      expect(result[:status]).to eq :bad_request
    end

    it 'fails' do
      expect(result).to be_failure
    end
  end

  context 'with valid type' do
    let(:type) { 'popular' }
    let(:popular_playlists) { [] }

    before do
      create(:playlist)
    end

    it 'succeeds' do
      expect(result).to be_success
    end

    it 'assigns model' do
      expect(result[:model]).to match_array(popular_playlists)
    end
  end

  context 'when feature toggle off' do
    let(:type) { 'popular' }

    before do
      Flipper.disable(:playlists_info_endpoint)
    end

    it 'fails' do
      expect(result).to be_failure
    end
  end
end
