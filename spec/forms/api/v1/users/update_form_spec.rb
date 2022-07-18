RSpec.describe Api::V1::Users::UpdateForm, type: :model do
  describe 'validations' do
    subject(:user) { described_class.new(User.new) }

    context 'with valid values' do
      context 'with valid avatar' do
        let(:avatar) { fixture_file_upload('spec/fixtures/avatar/test_avatar.png') }

        it 'allows valid' do
          expect(user).to allow_values(avatar).for(:avatar)
        end
      end
    end

    context 'with invalid values' do
      context 'with invalid avatar' do
        let(:avatar) { fixture_file_upload('spec/fixtures/avatar/wrong_type.gif') }

        it "don't allows invalid" do
          expect(user).not_to allow_values(avatar).for(:avatar)
        end
      end
    end
  end
end
