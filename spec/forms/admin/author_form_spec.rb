RSpec.describe Admin::AuthorForm, type: :model do
  describe 'fields' do
    subject(:author) { described_class.new(build(:author)) }

    it { is_expected.not_to allow_value(nil).for(:nickname) }
  end

  describe 'validations' do
    subject(:author) { described_class.new(build(:author)) }

    it { is_expected.not_to allow_value(nil).for(:nickname) }

    it do
      expect(author).to validate_length_of(:nickname)
        .is_at_least(described_class::NICKNAME_MIN_LENGTH).is_at_most(described_class::NICKNAME_MAX_LENGTH)
    end

    context 'with valid values' do
      let(:valid_nicknames) { ['author2022', 'black.white', 'black_white', 'black-white'] }

      it 'allows correct nicknames' do
        expect(author).to allow_values(*valid_nicknames)
          .for(:nickname)
      end
    end

    context 'with invalid nicknames' do
      let(:invalid_nicknames) do
        ['a', 'black..white', 'black__white', 'black_.white', 'black!white',
         '12345123451234512345123451234512345123456', '_abc', 'abc.']
      end

      it "doesn't allows incorrect values" do
        expect(author).not_to allow_values(*invalid_nicknames)
          .for(:nickname)
      end
    end
  end
end
