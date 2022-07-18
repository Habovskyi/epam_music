module Api
  module V1
    module Reaction
      class InfoSerializer < ApplicationSerializer
        set_type :reaction

        attributes :reaction_type

        belongs_to :playlist, serializer: Api::V1::Playlist::InfoSerializer
        belongs_to :user, serializer: Api::V1::User::InfoSerializer
      end
    end
  end
end
