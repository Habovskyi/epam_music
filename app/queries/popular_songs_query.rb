class PopularSongsQuery
  SONGS_LIMIT = 5
  class << self
    def call
      Song.where(id: Song.select(:id).joins('LEFT JOIN playlist_songs ON songs.id = song_id')
                   .joins('LEFT JOIN playlists ON playlists.id = playlist_id').group('songs.id')
                   .order('count(playlist_songs.song_id) desc NULLS LAST').limit(SONGS_LIMIT))
    end
  end
end
