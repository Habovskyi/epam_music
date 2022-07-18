RSpec.describe Api::V1::Users::CreateForm, type: :model do
  describe 'validations' do
    subject(:user) { described_class.new(User.new) }

    it { is_expected.to allow_value(nil).for(:password) }
    it { is_expected.to allow_value(nil).for(:password_confirmation) }

    context 'with valid values' do
      context 'with valid password' do
        let(:user) { described_class.new(create(:user)) }
        let(:passwords) { ['Password_123', 'Password+1'] }

        it { expect(user).to allow_values(*passwords).for(:password) }
      end
    end

    context 'with invalid values' do
      context 'with invalid password' do
        let(:user) { described_class.new(create(:user)) }
        let(:passwords) { %w[P password PASSWO?RD Pas12] }

        it do
          expect(user).not_to allow_values(passwords).for(:password)
        end
      end
    end
  end
end
