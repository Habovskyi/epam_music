# Comment model
class Comment < ApplicationRecord
  PER_PLAYLIST_PAGE = 20

  belongs_to :user
  belongs_to :playlist
end
