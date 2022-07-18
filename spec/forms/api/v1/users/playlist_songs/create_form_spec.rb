RSpec.describe Api::V1::Users::PlaylistSongs::CreateForm, type: :model do
  describe 'validations' do
    subject(:playlist_song) { described_class.new(build(:playlist_song)) }

    it { is_expected.to validate_presence_of(:song_id) }

    it 'checks presence of song' do
      playlist_song.validate(song_id: 'invalid')
      expect(playlist_song).not_to be_valid
    end

    context 'when dublicates' do
      let!(:playlist_song1) { create(:playlist_song) }
      let(:playlist_song2) do
        described_class.new(build(:playlist_song, playlist_id: playlist_song1.playlist_id,
                                                  song_id: playlist_song1.song_id))
      end

      it 'doesnt allow duplicates' do
        expect(playlist_song2).not_to be_valid
      end
    end
  end
end
