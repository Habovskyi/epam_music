# User model
class User < ApplicationRecord
  include AvatarUploader::Attachment(:avatar)
  include PgSearch::Model

  ACCESS_TOKEN_EXPIRATION = 30.minutes
  REFRESH_TOKEN_EXPIRATION = 1.day
  BEST_CONTRIBUTORS_LIMIT = 5
  FRIENDS_PER_PAGE = 20
  SEARCH_LIMIT = 10
  PLAYLISTS_PER_PAGE = 20

  has_many :friendship_from, class_name: 'Friendship', foreign_key: 'user_from_id',
                             inverse_of: :user_from, dependent: :destroy # list of sended invitations
  has_many :friendship_to, class_name: 'Friendship', foreign_key: 'user_to_id',
                           inverse_of: :user_to, dependent: :destroy # list of recieved invitations
  has_many :comments, dependent: :destroy

  has_secure_password

  has_many :playlists, dependent: :destroy
  has_many :playlist_songs, dependent: :destroy
  has_many :reactions, dependent: :destroy
  has_many :whitelisted_tokens, dependent: :destroy

  pg_search_scope :search,
                  against: :ts_vector,
                  using: { tsearch: { dictionary: 'english',
                                      prefix: true,
                                      any_word: true,
                                      tsvector_column: 'ts_search_vector' } }

  scope :best_contributors, -> { order(:playlists_created).reverse_order.limit(BEST_CONTRIBUTORS_LIMIT) }
  scope :most_friendly, MostFriendlyUsersQuery
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :friends, FriendsQuery
  scope :not_friends, NotFriendsQuery

  def user_and_shared_playlists
    ::Playlist.active.where(user_id: self).or(::Playlist.active.where(visibility: :shared, user_id: friends.ids))
  end

  def shared_playlists
    ::Playlist.active.shared.joins("INNER JOIN (#{friends.to_sql}) AS friends ON playlists.user_id = friends.id")
  end

  def friends
    User.friends(self)
  end

  def not_friends
    User.not_friends(self)
  end

  def friend_with?(user)
    Friendship.where(status: :accepted).and(Friendship.where(user_from: self, user_to: user)
      .or(Friendship.where(user_from: user, user_to: self))).exists?
  end

  def friendships
    Friendship.where(user_from: self).or(Friendship.where(user_to: self))
  end
end
