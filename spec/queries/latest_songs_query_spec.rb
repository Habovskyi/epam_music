RSpec.describe LatestSongsQuery, type: :query do
  let!(:latest_songs) { create_list(:song, 5) }

  before do
    create(:song, created_at: 1.day.ago)
  end

  it 'latest song' do
    expect(described_class.call).to match_array(latest_songs)
  end

  it 'return 5 songs' do
    expect(described_class.call.count).to eq(5)
  end
end
