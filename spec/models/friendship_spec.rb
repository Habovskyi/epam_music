RSpec.describe Friendship, type: :model do
  subject(:friendship) { build(:friendship) }

  describe 'fields' do
    it { is_expected.to belong_to(:user_from) }
    it { is_expected.to belong_to(:user_to) }
    it { is_expected.to have_db_column(:status).of_type(:integer) }
    it { is_expected.to define_enum_for(:status).with_values(%i[pending accepted declined]) }
  end
end
