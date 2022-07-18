module Api
  module V1
    module Friendship
      class DetailsSerializer < ApplicationSerializer
        set_type :friendship

        attributes :status

        attribute :incoming do |object, params|
          params[:current_user].id != object.user_from_id
        end

        belongs_to :user_from, serializer: Api::V1::User::InfoSerializer, record_type: :user
        belongs_to :user_to, serializer: Api::V1::User::InfoSerializer, record_type: :user
      end
    end
  end
end
