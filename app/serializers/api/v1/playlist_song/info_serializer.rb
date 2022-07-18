module Api
  module V1
    module PlaylistSong
      class InfoSerializer < ApplicationSerializer
        set_type :playlist_song

        belongs_to :song, serializer: Api::V1::Song::FullSerializer
        belongs_to :user, serializer: Api::V1::User::InfoSerializer, if: proc { |_, params| params && params[:shared] }

        def self.includes
          %i[song song.author song.album song.genre user]
        end
      end
    end
  end
end
