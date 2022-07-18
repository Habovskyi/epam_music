# Playlist model
class Playlist < ApplicationRecord
  include LogoUploader::Attachment(:logo)
  include PgSearch::Model

  HOME_QUERY_LIMIT = 5
  HOME_SONGS_LIMIT = 10
  SEARCH_LIMIT = 10
  SONGS_PER_PAGE = 20

  pg_search_scope :search_public, against: :ts_vector_public,
                                  using: { tsearch: { dictionary: 'english',
                                                      prefix: true,
                                                      any_word: true,
                                                      tsvector_column: 'ts_vector_public' } },
                                  order_within_rank: 'playlists.created_at DESC'

  belongs_to :user
  has_many :reactions, dependent: :destroy
  has_many :playlist_songs, dependent: :destroy
  has_many :songs, through: :playlist_songs
  has_many :comments, dependent: :destroy
  has_many :limited_songs, -> { limit(HOME_SONGS_LIMIT) }, through: :playlist_songs, source: :song

  scope :featured, -> { where(featured: true).limit(HOME_QUERY_LIMIT) }
  scope :latest_added, -> { general.order(created_at: :desc).limit(HOME_QUERY_LIMIT) }
  scope :popular, PopularPlaylistsQuery
  scope :general_home, ->(sort_params) { PublicPlaylistsQuery.call(**sort_params) }
  scope :active, ActivePlaylistsQuery
  scope :general, -> { where(visibility: :general) }

  enum visibility: { personal: 0, general: 1, shared: 2 }
end
