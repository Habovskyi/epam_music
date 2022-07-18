RSpec.describe StatisticMailer, type: :mailer do
  describe 'statistic mail' do
    before do
      create_list(:admin_user, 2)
    end

    let!(:statistic) { create(:statistic) }
    let!(:statistic_to_compare) { create(:statistic) }
    let(:time_period) { 24.hours }
    let(:mail) { described_class.statistic_mail(statistic, statistic_to_compare, time_period) }

    it 'renders the subject' do
      expect(mail.subject).to eq(I18n.t('action_mailer.statistic.subjects.send',
                                        time_period: time_period.parts.map { |k, v| "#{v} #{k}" }.join,
                                        current_date: Time.zone.now.strftime(described_class::DATE_FORMAT)))
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq(::AdminUser.pluck(:email))
    end

    it 'sends email' do
      expect { mail.deliver_now }.to(change { ActionMailer::Base.deliveries.count }.by(1))
    end
  end
end
