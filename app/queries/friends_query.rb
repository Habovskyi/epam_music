class FriendsQuery
  class << self
    def call(current_user)
      accepted_frinendships = "SELECT friendships.* FROM friendships
                               WHERE (friendships.user_from_id = '#{current_user.id}'
                               OR friendships.user_to_id = '#{current_user.id}') AND friendships.status = 1"
      User.active.where.not(id: current_user.id)
          .joins("INNER JOIN (#{accepted_frinendships}) AS friendships " \
                 'ON  users.id = friendships.user_from_id OR users.id = friendships.user_to_id')
    end
  end
end
