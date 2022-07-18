module Api
  module V1
    module Friendships
      class CreateForm < ApplicationForm
        model :friendship

        property :user_from_id, writeable: false
        property :user_to_id

        validates :user_from_id, comparison: { other_than: :user_to_id }
        validates :user_to_id, presence: true
        validate :uniqueness_of_friendship
        validate :user_to_exists

        private

        def user_to_exists
          errors.add(:user_to_id, :not_exist, id: user_to_id) unless ::User.where(id: user_to_id).exists?
        end

        def uniqueness_of_friendship
          similar_record = ::Friendship.where(user_from_id:, user_to_id:)
                                       .or(::Friendship.where(user_from_id: user_to_id, user_to_id: user_from_id))
          return unless similar_record.exists?

          errors.add(:base, :already_exists, ids: [user_from_id, user_to_id])
        end
      end
    end
  end
end
