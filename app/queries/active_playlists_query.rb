class ActivePlaylistsQuery
  ACTIVE_USER = User.active.to_sql

  class << self
    def call(initial_scope = Playlist.all)
      scope = initial_scope.where(deleted_at: nil)
      filter_active_playlist(scope)
    end

    def filter_active_playlist(scope)
      scope.joins("INNER JOIN (#{ACTIVE_USER}) \"active_users\" " \
                  'ON "playlists"."user_id" = "active_users"."id"')
    end
  end
end
