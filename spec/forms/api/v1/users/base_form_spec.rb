RSpec.describe Api::V1::Users::BaseForm, type: :model do
  describe 'validations' do
    subject(:user) { described_class.new(User.new) }

    it { is_expected.not_to allow_value(nil).for(:username) }
    it { is_expected.not_to allow_value(nil).for(:email) }
    it { is_expected.to allow_value(nil).for(:first_name) }
    it { is_expected.to allow_value(nil).for(:last_name) }

    it do
      expect(user).to validate_length_of(:username)
        .is_at_least(described_class::USERNAME_MIN_LENGTH).is_at_most(described_class::USERNAME_MAX_LENGTH)
    end

    it do
      expect(user).to validate_length_of(:first_name)
        .is_at_least(described_class::NAME_MIN_LENGTH).is_at_most(described_class::NAME_MAX_LENGTH)
    end

    it do
      expect(user).to validate_length_of(:last_name)
        .is_at_least(described_class::NAME_MIN_LENGTH).is_at_most(described_class::NAME_MAX_LENGTH)
    end

    context 'with valid values' do
      context 'with valid emails' do
        let(:valid_emails) { ['test@mail.com', 'test2@mail.com', 'test_3@mail.ua'] }

        it 'allows correct emails' do
          expect(user).to allow_values(*valid_emails)
            .for(:email)
        end
      end

      context 'with valid names' do
        let(:valid_first_names) { %w[TestName Testname test-name] }
        let(:valid_last_names) { %w[TestLastName Testlastname test-last-name] }

        it 'allows correct first_name' do
          expect(user).to allow_values(*valid_first_names)
            .for(:first_name)
        end

        it 'allows correct last_name' do
          expect(user).to allow_values(*valid_last_names)
            .for(:last_name)
        end
      end

      context 'with valid username' do
        let(:valid_usernames) { %w[TestLastUserName Username user.over_test] }

        it 'allows correct usernames' do
          expect(user).to allow_values(*valid_usernames)
            .for(:username)
        end
      end
    end

    context 'with invalid values' do
      context 'with invalid emails' do
        let(:invalid_emails) { ['too long email\'s title', '7', '_for_home', 'test@.school party'] }

        it "doesn't allow invalid emails" do
          expect(user).not_to allow_values(*invalid_emails)
            .for(:email)
        end
      end

      context 'with invalid names' do
        let(:invalid_first_names) { ['4', '7some_invalid--Name', 'tesT124315firsT2name'] }
        let(:invalid_last_names) { ['Last4Name', '-lastInvalidnname', '_last_name'] }

        it "doesn't allow invalid first names" do
          expect(user).not_to allow_values(*invalid_first_names)
            .for(:first_name)
        end

        it "doesn't allow invalid last names" do
          expect(user).not_to allow_values(*invalid_last_names)
            .for(:last_name)
        end
      end

      context 'with invalid username' do
        let(:invalid_usernames) { ['228--UserName', '-userName', '_user_name'] }

        it "doesn't allow invalid usernames" do
          expect(user).not_to allow_values(*invalid_usernames)
            .for(:username)
        end
      end
    end
  end
end
