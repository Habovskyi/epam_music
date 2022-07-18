module Api
  module V1
    module Comment
      class InfoSerializer < ApplicationSerializer
        set_type :comment
        attributes :text
        belongs_to :user, serializer: Api::V1::User::PlaylistOwnerSerializer
        belongs_to :playlist, serializer: Api::V1::Playlist::InfoSerializer

        def self.includes
          %i[user playlist]
        end
      end
    end
  end
end
