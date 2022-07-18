class LatestSongsQuery
  LATEST_SONG_LIMIT = 5

  class << self
    def call(initial_scope = Song.all)
      initial_scope.order(created_at: :desc).limit(LATEST_SONG_LIMIT)
    end
  end
end
