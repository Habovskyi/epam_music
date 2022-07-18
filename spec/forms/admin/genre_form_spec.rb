describe Admin::GenreForm, type: :model do
  describe 'validations' do
    subject(:genre) { described_class.new(build(:genre)) }

    it { is_expected.to validate_presence_of(:name) }

    it do
      expect(genre).to validate_length_of(:name)
        .is_at_least(described_class::NAME_MIN_LENGTH).is_at_most(described_class::NAME_MAX_LENGTH)
    end

    context 'with valid values' do
      let(:valid_names) { ['ABCD', 'ABC CBD', 'abc & cba', 'Heroes'] }

      it 'allow correct name' do
        expect(genre).to allow_values(*valid_names)
          .for(:name)
      end
    end

    context 'with invalid values' do
      let(:invalid_names) { ['A', 'abc123abc123abc123abc123abc123abc123abc123abc', 'abc.abc', 'abc!'] }

      it "doesn't allows names" do
        expect(genre).not_to allow_values(*invalid_names)
          .for(:name)
      end
    end

    context 'when save genre objects' do
      let(:genre_copy) { described_class.new(build(:genre, name: genre.name)) }

      it 'valid genre' do
        expect(genre).to be_valid
      end

      it 'invalid genre' do
        genre.save
        expect(genre_copy).not_to be_valid
      end
    end

    context 'when update genre objects' do
      let(:genre_form) { described_class.new(build(:genre)) }
      let(:valid_genre_name) { build(:genre).name }

      it 'is expected successful update' do
        genre_form.validate(name: valid_genre_name)
        expect(genre_form.save).to be_truthy
      end

      it 'is expected unsuccessful update' do
        genre_form.save
        expect(genre_form.validate(name: genre_form.name)).to be_falsey
      end
    end
  end
end
