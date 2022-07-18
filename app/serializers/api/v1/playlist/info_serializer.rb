module Api
  module V1
    module Playlist
      class InfoSerializer < BaseSerializer
        set_type :playlist
        attributes :updated_at
        has_many :songs, record_type: :song, serializer: Api::V1::Song::FullSerializer
        belongs_to :user, key: :owner, serializer: Api::V1::User::PlaylistOwnerSerializer

        def self.includes
          super + %i[songs songs.author songs.album songs.genre]
        end
      end
    end
  end
end
