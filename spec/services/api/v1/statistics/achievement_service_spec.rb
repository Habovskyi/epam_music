RSpec.describe Api::V1::Statistics::AchievementService, type: :service do
  subject(:service) { described_class.new(user).call }

  let(:user) { create(:user, playlists_created: count) }
  let(:count) { ::Api::V1::Statistics::AchievementService::ACHIEVEMENT_GOALS.sample }

  context 'when user reached an achievement goal' do
    it 'send email notification' do
      expect { service }.to have_enqueued_mail(UserMailer, :achievement_notification_mail)
    end
  end

  context 'when user does not reached an achievement goal' do
    let(:count) { ::Api::V1::Statistics::AchievementService::ACHIEVEMENT_GOALS.sample + 1 }

    it 'send email notification' do
      expect { service }.not_to have_enqueued_mail(UserMailer, :achievement_notification_mail)
    end
  end
end
