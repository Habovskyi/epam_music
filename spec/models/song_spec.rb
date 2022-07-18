RSpec.describe Song, type: :model do
  describe 'fields' do
    it { is_expected.to have_db_column(:title).of_type(:string) }
    it { is_expected.to have_db_column(:author_id).of_type(:uuid) }
    it { is_expected.to have_db_column(:album_id).of_type(:uuid) }
    it { is_expected.to have_db_column(:genre_id).of_type(:uuid) }
    it { is_expected.to have_db_column(:featured).of_type(:boolean) }
    it { is_expected.to have_db_column(:count_listening).of_type(:integer) }

    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:album).optional }
    it { is_expected.to belong_to(:author).required }
    it { is_expected.to belong_to(:genre).required }
    it { is_expected.to have_many(:playlist_songs).dependent(:destroy) }
    it { is_expected.to have_many(:playlists) }
  end

  describe 'search' do
    context 'with title search' do
      let(:search_word) { 'title' }
      let!(:search_title) { create(:song, title: "search #{search_word} search") }

      before do
        create(:song, title: 'random')
      end

      it 'search and return propper result' do
        expect(described_class.search(search_word).first).to match(search_title)
      end
    end

    context 'with author search' do
      let(:search_word) { 'author' }
      let!(:search_author) { create(:song, author: create(:author, nickname: "search #{search_word} search")) }

      before do
        create(:song, author: create(:author, nickname: 'random'))
      end

      it 'search and return propper result' do
        expect(described_class.search(search_word).first).to match(search_author)
      end
    end

    context 'with album search' do
      let(:search_word) { 'album' }
      let!(:search_album) { create(:song, album: create(:album, title: "search #{search_word} search")) }

      before do
        create(:song, album: create(:album, title: 'random'))
      end

      it 'search and return propper result' do
        expect(described_class.search(search_word).first).to match(search_album)
      end
    end

    context 'with genre search' do
      let(:search_word) { 'genre' }
      let!(:search_genre) { create(:song, genre: create(:genre, name: "se #{search_word} ch")) }

      before do
        create(:song, genre: create(:genre, name: 'random'))
      end

      it 'search and return propper result' do
        expect(described_class.search(search_word).first).to match(search_genre)
      end
    end
  end
end
