class PopularPlaylistsQuery
  MIN_SONGS_COUNT = 5
  PLAYLIST_LIMIT = 5
  CREATED = 1.month
  GROUPED_SONGS_SQL = PlaylistSong.select(:playlist_id, 'count(playlist_songs.id) songs_count')
                                  .group('playlist_id').to_sql
  GROUPED_LIKES_SQL = Reaction.select(:playlist_id, 'count(id) likes_count')
                              .where(reaction_type: :liked)
                              .group('playlist_id').to_sql

  class << self
    def call(initial_scope = Playlist.active.all)
      scope = initial_scope.general
      scope = scope.where(created_at: ..CREATED.ago)
      scope = filter_songs_count(scope)
      scope = filter_likes_count(scope)
      scope.limit(PLAYLIST_LIMIT)
    end

    def filter_songs_count(scope)
      scope.joins("LEFT JOIN (#{GROUPED_SONGS_SQL}) \"grouped_songs\" " \
                  'ON "grouped_songs"."playlist_id" = "playlists"."id"')
           .where('songs_count > ?', MIN_SONGS_COUNT)
    end

    def filter_likes_count(scope)
      scope.joins("LEFT JOIN (#{GROUPED_LIKES_SQL}) \"grouped_likes\" " \
                  'ON "grouped_likes"."playlist_id" = "playlists"."id"')
           .where.not(grouped_likes: { likes_count: nil })
           .order(likes_count: :desc)
    end
  end
end
