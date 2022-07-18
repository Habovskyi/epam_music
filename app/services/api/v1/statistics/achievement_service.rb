module Api
  module V1
    module Statistics
      class AchievementService < ApplicationService
        ACHIEVEMENT_GOALS = [10, 100, 1000, 10_000].freeze

        attr_reader :user

        def initialize(user)
          @user = user
        end

        def call
          send_notification if reached_achievement_goal?
        end

        private

        def reached_achievement_goal?
          ACHIEVEMENT_GOALS.include?(user.playlists_created)
        end

        def send_notification
          UserMailer.with(user:).achievement_notification_mail.deliver_later
        end
      end
    end
  end
end
