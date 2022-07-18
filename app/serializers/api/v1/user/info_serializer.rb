module Api
  module V1
    module User
      class InfoSerializer < ApplicationSerializer
        attributes :username, :email, :first_name, :last_name

        attribute :avatar do |object|
          AvatarUploader::THUMBNAILS_SIZES.keys.index_with do |key|
            object.avatar_url(key)
          end
        end
      end
    end
  end
end
