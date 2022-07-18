RSpec.describe FriendshipMailer, type: :mailer do
  let(:friendship) { create(:friendship) }

  describe 'send invitation' do
    let(:mail) { described_class.with(friendship:).invintation_mail }

    it 'renders the subject' do
      expect(mail.subject).to eq(I18n.t('action_mailer.friendships.subjects.invintation_mail'))
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([friendship.user_to.email])
    end

    it 'sends email' do
      expect { mail.deliver_now }.to(change { ActionMailer::Base.deliveries.count }.by(1))
    end
  end

  describe 'acceped invitation' do
    let(:mail) { described_class.with(friendship:).accepted_mail }

    it 'renders the subject' do
      expect(mail.subject).to eql(I18n.t('action_mailer.friendships.subjects.accepted_email'))
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([friendship.user_from.email])
    end

    it 'sends email' do
      expect { mail.deliver_now }.to(change { ActionMailer::Base.deliveries.count }.by(1))
    end
  end

  describe 'declined invitation' do
    let(:mail) { described_class.with(user_to: friendship.user_to, user_from: friendship.user_from).declined_mail }

    it 'renders the subject' do
      expect(mail.subject).to eql(I18n.t('action_mailer.friendships.subjects.declined_email'))
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([friendship.user_from.email])
    end

    it 'sends email' do
      expect { mail.deliver_now }.to(change { ActionMailer::Base.deliveries.count }.by(1))
    end
  end
end
