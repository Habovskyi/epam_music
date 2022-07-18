module Api
  module V1
    class PlaylistPolicy < ApplicationPolicy
      authorize :user, optional: true

      def destroy?
        user.id == record.user_id
      end

      def update?
        owner?
      end

      def show?
        record.general? ||
          (user.present? &&
          (owner? ||
          (record.shared? && friend?)))
      end

      def owner?
        user == record.user
      end

      def friend?
        user.friend_with?(record.user)
      end
    end
  end
end
