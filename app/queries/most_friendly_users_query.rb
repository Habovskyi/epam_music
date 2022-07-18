class MostFriendlyUsersQuery
  MOST_FRIENDLY_LIMIT = 5
  class << self
    def call
      User.select(:id, :username, :email, :first_name, :last_name, :playlists_created, 'count(users.id) friends_count')
          .active
          .joins('LEFT JOIN friendships f on users.id = f.user_from_id or users.id = f.user_to_id')
          .where(f: { status: Friendship.statuses[:accepted] })
          .group(:id, :username).order('friends_count DESC', email: :asc)
          .limit(MOST_FRIENDLY_LIMIT)
    end
  end
end
