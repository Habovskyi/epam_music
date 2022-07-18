RSpec.describe Author, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:songs).dependent(:destroy) }
  end
end
