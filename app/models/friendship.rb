# Friend relation between two users
class Friendship < ApplicationRecord
  INDEX_LIMIT = 10

  enum status: {
    pending: 0,
    accepted: 1,
    declined: 2
  }

  belongs_to :user_from, class_name: 'User'
  belongs_to :user_to, class_name: 'User'
end
