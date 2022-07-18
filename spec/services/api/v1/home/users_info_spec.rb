RSpec.describe Api::V1::Home::UsersInfo, type: :service do
  subject(:result) { described_class.call(type:) }

  let(:type) { 'invalid' }

  before do
    Flipper.enable(:users_info_endpoint)
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
    let(:type) { 'most_friendly' }
    let(:most_friendly_users) { [] }

    before do
      create(:user)
    end

    it 'succeeds' do
      expect(result).to be_success
    end

    it 'assigns model' do
      expect(result[:model]).to match_array(most_friendly_users)
    end
  end

  context 'when feature toggle off' do
    before do
      Flipper.disable(:users_info_endpoint)
    end

    it 'fails' do
      expect(result).to be_failure
    end
  end
end
