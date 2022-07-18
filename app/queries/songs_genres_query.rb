class SongsGenresQuery
  GENRES_LIMIT = 5
  SONGS_LIMIT = 10
  TOP_GENRES = Genre.where(id: Genre.select(:id).joins('LEFT JOIN songs ON genres.id = genre_id').group('genres.id')
                    .order('count(songs.genre_id) desc').limit(GENRES_LIMIT)).to_sql

  class << self
    def call(initial_scope = Song.all)
      initial_scope.joins("LEFT JOIN (#{TOP_GENRES}) \"genres\" ON songs.genre_id = genres.id")
                   .order(count_listening: :desc)
                   .limit(SONGS_LIMIT)
    end
  end
end
