# Song model
class Song < ApplicationRecord
  include PgSearch::Model

  SEARCH_LIMIT = 20

  belongs_to :album, optional: true, touch: true
  belongs_to :genre, touch: true
  belongs_to :author, touch: true

  has_many :playlist_songs, dependent: :destroy
  has_many :playlists, through: :playlist_songs

  pg_search_scope :search, against: :ts_vector,
                           using: { tsearch: { dictionary: 'english',
                                               prefix: true,
                                               any_word: true,
                                               tsvector_column: 'ts_search_vector' } },
                           order_within_rank: 'songs.created_at DESC'

  scope :popular, PopularSongsQuery
  scope :latest, LatestSongsQuery
  scope :by_genres, SongsGenresQuery
end
