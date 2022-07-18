module Api
  module V1
    module Users
      module PlaylistSongs
        class CreateForm < ApplicationForm
          model :playlist_song

          property :song_id
          property :playlist_id, writeable: false

          validate :song_uniqueness_in_playlist
          validates :song_id, presence: true, association_exist: true

          private

          def song_uniqueness_in_playlist
            return unless ::PlaylistSong.where(song_id:, playlist_id:).exists?

            errors.add(:song_id, :already_exists)
          end
        end
      end
    end
  end
end
