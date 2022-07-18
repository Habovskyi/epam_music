class NotFriendsQuery
  class << self
    def call(current_user)
      User.active.excluding(current_user.friends, current_user)
    end
  end
end
