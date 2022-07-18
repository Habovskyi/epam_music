RSpec.describe Comment, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:playlist) }
  end

  describe 'fields' do
    it { is_expected.to have_db_column(:id).of_type(:uuid).with_options(null: false) }
    it { is_expected.to have_db_column(:user_id).of_type(:uuid).with_options(null: false) }
    it { is_expected.to have_db_column(:playlist_id).of_type(:uuid).with_options(null: false) }
    it { is_expected.to have_db_column(:text).of_type(:text).with_options(null: false) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
  end

  describe 'validations' do
    subject(:comment) { build(:comment) }

    it { is_expected.not_to validate_presence_of(:user_id) }
    it { is_expected.not_to validate_presence_of(:playlist_id) }
  end
end
