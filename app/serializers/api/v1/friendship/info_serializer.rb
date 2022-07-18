module Api
  module V1
    module Friendship
      class InfoSerializer < ApplicationSerializer
        set_type :friendship

        attributes :status

        belongs_to :user_from, serializer: Api::V1::User::InfoSerializer, record_type: :user
        belongs_to :user_to, serializer: Api::V1::User::InfoSerializer, record_type: :user
      end
    end
  end
end
