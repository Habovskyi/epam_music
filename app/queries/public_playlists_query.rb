class PublicPlaylistsQuery
  GROUPED_LIKES_SQL = Reaction.select(:playlist_id, 'count(id) likes_count')
                              .where(reaction_type: :liked)
                              .group('playlist_id').to_sql
  GROUPED_COMMENTS_SQL = Comment.select(:playlist_id, 'count(id) comments_count')
                                .group('playlist_id').to_sql

  ASC = :asc
  SORT_OPTIONS = %w[title comments_count].index_with(&:to_sym).freeze
  DEFAULT_SORT = :default

  def self.call(initial_scope = Playlist.active.all, **params)
    new(initial_scope, **params).call
  end

  def initialize(initial_scope, **params)
    @scope = initial_scope.general
    @params = HashWithIndifferentAccess.new(params)
  end

  def call
    search if search_query
    sort
    includes
  end

  private

  def includes
    # TODO: replace with parser
    @scope.includes(:user, { limited_songs: %i[author genre album] })
  end

  def search
    @scope = @scope.from("(#{Playlist.search_public(search_query).to_sql}) AS playlists")
  end

  def search_query
    @params[:s]
  end

  def sort
    @scope = (sort_by == DEFAULT_SORT && search_query ? @scope : send("sort_#{sort_by}"))
  end

  def sort_by
    @sort_by ||= SORT_OPTIONS.fetch(@params[:sort_by]&.downcase, DEFAULT_SORT)
  end

  def sort_order
    @sort_order ||= (@params[:sort_order]&.downcase&.to_sym == ASC ? ASC : :desc)
  end

  def sort_default
    @scope.joins("LEFT JOIN (#{GROUPED_LIKES_SQL}) \"grouped_likes\" " \
                 'ON "grouped_likes"."playlist_id" = "playlists"."id"')
          .order("likes_count #{sort_order} #{nulls_order}, created_at #{sort_order}")
  end

  def sort_title
    @scope.order(title: sort_order.to_sym)
  end

  def sort_comments_count
    @scope.joins("LEFT JOIN (#{GROUPED_COMMENTS_SQL}) \"grouped_comments\" " \
                 'ON "grouped_comments"."playlist_id" = "playlists"."id"')
          .order("comments_count #{sort_order} #{nulls_order}")
  end

  def nulls_order
    sort_order == ASC ? 'NULLS FIRST' : 'NULLS LAST'
  end
end
