RSpec.describe Api::V1::Users::Update, type: :service do
  subject(:result) { described_class.call(model:, params:) }

  let!(:model) { create(:user) }
  let(:params) { { username: } }

  before do
    result
  end

  describe 'succeeds' do
    let(:username) { 'valid.name' }

    it 'succeeds' do
      expect(result).to be_success
    end

    it 'updates model' do
      expect(result[:model].username).to eq username
    end
  end

  describe 'failure' do
    let(:username) { 'in' }

    it 'fails' do
      expect(result).to be_failure
    end

    it 'return errors' do
      expect(result.errors).not_to be_empty
    end
  end
end
