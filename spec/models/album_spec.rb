RSpec.describe Album, type: :model do
  describe 'fields' do
    it { is_expected.to have_db_column(:id).of_type(:uuid) }
    it { is_expected.to have_db_column(:title).of_type(:string) }

    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:songs).dependent(:destroy) }
  end
end
