FactoryBot.define do
  factory :statistic do
    new_users { rand(0..10) }
    new_deleted_users { rand(0..10) }
    new_playlists { rand(0..10) }
    new_deleted_playlists { rand(0..10) }
    new_playlist_songs { rand(0..10) }
    new_friendships { rand(0..10) }
    new_accepted_friendships { rand(0..10) }
    new_songs { rand(0..10) }
    new_genres { rand(0..10) }
    new_authors { rand(0..10) }
    total_users { rand(0..10) }
    total_deleted_users { rand(0..10) }
    total_playlists { rand(0..10) }
    total_songs { rand(0..10) }
    total_genres { rand(0..10) }
    total_authors { rand(0..10) }
  end
end
