module Api
  module V1
    module User
      class PlaylistOwnerSerializer < ApplicationSerializer
        set_type :user
        attributes :username
      end
    end
  end
end
