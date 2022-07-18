# PlaylistSong model
class PlaylistSong < ApplicationRecord
  belongs_to :user
  belongs_to :playlist, touch: true
  belongs_to :song, touch: true
end
