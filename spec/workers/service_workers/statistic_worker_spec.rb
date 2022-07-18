require 'sidekiq/testing'

Sidekiq::Testing.inline!

describe ServiceWorkers::StatisticWorker, type: :worker do
  let(:time) { 24.hours }

  before do
    user = create(:user)
    create(:playlist, deleted_at: Time.zone.now, user:)
    create(:playlist, user:)
    create(:user, active: false)
    create(:statistic, created_at: time)
    described_class.perform_async
  end

  it 'generate statistic' do
    expect(::Statistic.count).to eq 2
  end

  it 'destroy inactive users' do
    expect(::User.count).to eq 1
  end

  it 'destroy deleted playlists' do
    expect(::Playlist.count).to eq 1
  end

  it 'send mail' do
    expect do
      described_class.perform_async
    end.to have_enqueued_mail(StatisticMailer, :statistic_mail)
  end
end
