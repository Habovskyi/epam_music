module Api
  module V1
    module Playlist
      class HomeSerializer < BaseSerializer
        set_type :playlist
        has_many :limited_songs, key: :songs, record_type: :song, serializer: Api::V1::Song::FullSerializer

        def self.includes
          super + %i[limited_songs limited_songs.author limited_songs.album limited_songs.genre]
        end
      end
    end
  end
end
