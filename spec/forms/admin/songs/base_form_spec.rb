describe Admin::Songs::BaseForm, type: :model do
  describe 'validations' do
    subject(:song) { described_class.new(build(:song)) }

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.not_to validate_presence_of(:album_id) }
    it { is_expected.to validate_presence_of(:author_id) }
    it { is_expected.to validate_presence_of(:genre_id) }

    it do
      expect(song).to validate_length_of(:title)
        .is_at_least(described_class::TITLE_MIN_LENGTH).is_at_most(described_class::TITLE_MAX_LENGTH)
    end

    context 'with valid values' do
      let(:valid_titles) { ['ABCD', 'ABC CBD', 'ABC123', 'ABC (Remix)', 'abc-123', 'Heroes'] }

      it 'allow correct title' do
        expect(song).to allow_values(*valid_titles)
          .for(:title)
      end
    end

    context 'with invalid values' do
      let(:invalid_titles) { ['A', 'abc123abc123abc123abc123abc123abc123abc123abc', 'abc.abc', 'abc!'] }

      it "doesn't allows titles" do
        expect(song).not_to allow_values(*invalid_titles)
          .for(:title)
      end
    end

    context 'when save song objects' do
      let(:song_copy) { described_class.new(build(:song, title: song.title, author_id: song.author_id)) }

      before do
        song.save
      end

      it 'valid song' do
        expect(song).to be_valid
      end

      it 'invalid song' do
        expect(song_copy).not_to be_valid
      end
    end

    context 'when update song objects' do
      let(:song_for_update) { described_class.new(create(:song, featured: true)) }
      let(:song_for_update_copy) { described_class.new(create(:song)) }

      it 'is expected successful update' do
        song_for_update.validate(featured: false)
        expect(song_for_update.save).to be_truthy
      end

      it 'is expected unsuccessful update' do
        expect(song_for_update_copy.validate(title: song_for_update.title,
                                             author_id: song_for_update.author_id)).to be_falsey
      end
    end
  end
end
