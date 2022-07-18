RSpec.describe Api::V1::Users::Destroy, type: :service do
  subject(:result) { described_class.call(model:) }

  let!(:model) { create(:user) }

  before do
    result
  end

  describe 'succeeds' do
    it { expect(model.reload).not_to be_active }
  end
end
