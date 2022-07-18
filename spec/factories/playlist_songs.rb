FactoryBot.define do
  factory :playlist_song do
    user { create(:user) }
    playlist { create(:playlist) }
    song { create(:song) }
  end
end
