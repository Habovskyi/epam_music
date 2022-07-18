RSpec.describe Api::V1::Initializers::InitialDataFiller, type: :service do
  describe '.call' do
    context 'when certain values' do
      before do
        options = {
          user_count: 10,
          friendship_count: 5,
          author_count: 5,
          album_count: 5,
          genre_count: 5,
          song_count: 10,
          playlist_count: 5,
          comment_count: 2,
          reaction_count: 2,
          playlist_song_count: 2
        }

        described_class.call(options)
      end

      let(:comments) { 2 }
      let(:reactions) { 2 }
      let(:playlist_song_count) { 2 }

      it 'to be right user quantity' do
        expect(::User.count).to eq(10)
      end

      it 'to be right friendship quantity' do
        expect(::Friendship.count).to eq(5)
      end

      it 'to be right author quantity' do
        expect(::Author.count).to eq(5)
      end

      it 'to be right album quantity' do
        expect(::Album.count).to eq(5)
      end

      it 'to be right genre quantity' do
        expect(::Genre.count).to eq(5)
      end

      it 'to be right song quantity' do
        expect(::Song.count).to eq(10)
      end

      it 'to be right playlist quantity' do
        expect(::Playlist.count).to eq(5)
      end

      it 'to be right comment quantity' do
        expect(::Comment.count).to eq(comments * ::Playlist.count)
      end

      it 'to be right reaction quantity' do
        expect(::Reaction.count).to eq(reactions * ::Playlist.count)
      end

      it 'to be right playlist_cong quantity' do
        expect(::PlaylistSong.count).to eq(playlist_song_count * ::Playlist.count)
      end
    end

    context 'when without certain values' do
      before do
        default = {
          user: rand(10..15),   friendship: rand(5..7),
          author: rand(5..7),   album: rand(5..10),
          genre: rand(5..7),    song: rand(14..15),
          playlist: rand(5..7), comment: rand(1..2),
          reaction: rand(1..2), playlist_song: rand(1..2)
        }

        stub_const('Api::V1::Initializers::InitialDataFiller::ENTITIES', default)

        described_class.call({})
      end

      let(:abouts_count) { 1 }

      it 'to be right user quantity' do
        expect(::User.count).to be_between(10, 15)
      end

      it 'to be right friendship quantity' do
        expect(::Friendship.count).to be_between(5, 7)
      end

      it 'to be right author quantity' do
        expect(::Author.count).to be_between(5, 7)
      end

      it 'to be right album quantity' do
        expect(::Album.count).to be_between(5, 10)
      end

      it 'to be right genre quantity' do
        expect(::Genre.count).to be_between(5, 7)
      end

      it 'to be right song quantity' do
        expect(::Song.count).to be_between(14, 15)
      end

      it 'to be right playlist quantity' do
        expect(::Playlist.count).to be_between(5, 7)
      end

      it 'to be right comments quantity' do
        expect(::Comment.count).to be_between(5, 14)
      end

      it 'to be right reactions quantity' do
        expect(::Reaction.count).to be_between(5, 14)
      end

      it 'to be right playlists_songs quantity' do
        expect(::PlaylistSong.count).to be_between(5, 14)
      end

      it 'to have about' do
        expect(::About.count).to eq(abouts_count)
      end
    end
  end
end
