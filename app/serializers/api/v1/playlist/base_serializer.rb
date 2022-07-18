module Api
  module V1
    module Playlist
      class BaseSerializer < ApplicationSerializer
        set_type :playlist
        attributes :title, :visibility, :featured, :description, :created_at
        attribute :logo do |object|
          LogoUploader::THUMBNAILS_SIZES.keys.index_with do |key|
            object.logo_url(key)
          end
        end
        meta do |object|
          { comments_count: object.comments.count,
            songs_count: object.songs.count,
            likes_count: object.reactions.liked.count,
            dislikes_count: object.reactions.disliked.count }
        end
        belongs_to :user, key: :owner, serializer: Api::V1::User::PlaylistOwnerSerializer

        def self.includes
          %i[user]
        end
      end
    end
  end
end
