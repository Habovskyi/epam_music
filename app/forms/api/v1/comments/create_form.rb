module Api
  module V1
    module Comments
      class CreateForm < ApplicationForm
        TEXT_MIN_LENGTH = 3
        TEXT_MAX_LENGTH = 100
        COOLDOWN_TIME = 1.minute

        model :comment

        property :text
        property :user, writeable: false

        validates :text, presence: true, length: { in: TEXT_MIN_LENGTH..TEXT_MAX_LENGTH }
        validate :comment_cooldown

        private

        def comment_cooldown
          last_comment = user.comments.order(:created_at).last
          return if last_comment.blank?

          errors.add(:base, :invalid, time: last_comment.created_at) if last_comment.created_at > COOLDOWN_TIME.ago
        end
      end
    end
  end
end
