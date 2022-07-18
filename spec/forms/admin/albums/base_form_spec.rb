describe Admin::Albums::BaseForm, type: :model do
  describe 'validations' do
    subject(:album) { described_class.new(build(:album)) }

    it { is_expected.not_to allow_value(nil).for(:title) }

    it do
      expect(album).to validate_length_of(:title)
        .is_at_least(described_class::TITLE_MIN_LENGTH).is_at_most(described_class::TITLE_MAX_LENGTH)
    end

    context 'with valid title' do
      let(:valid_titles) { ['abc123', 'abc', '123', 'abc 123'] }

      it 'allows correct titles' do
        expect(album).to allow_values(*valid_titles)
          .for(:title)
      end
    end

    context 'with invalid title' do
      let(:invalid_titles) do
        ['abc_123', 'abc.123', 'abc 123 abc 123 abc 123 abc 123 abc 123 abc 123 abc 123 abc 123 abc 123']
      end

      it "doesn't allow incorrect titles" do
        expect(album).not_to allow_values(*invalid_titles)
          .for(:title)
      end
    end
  end
end
