RSpec.describe UserMailer, type: :mailer do
  describe 'send achievement notification' do
    let(:user) { create(:user, playlists_created: 10) }
    let(:mail) { described_class.with(user:).achievement_notification_mail }

    it 'renders the subject' do
      expect(mail.subject).to eq(I18n.t('action_mailer.users.subjects.achievement_notification'))
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'sends email' do
      expect { mail.deliver_now }.to(change { ActionMailer::Base.deliveries.count }.by(1))
    end
  end
end
