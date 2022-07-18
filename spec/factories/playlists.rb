FactoryBot.define do
  factory :playlist do
    association :user
    sequence(:title) { |n| "AB#{n}" }
    logo_data { nil }
    visibility { rand(2) }
    featured { FFaker::Boolean.random }
    description { FFaker::Lorem.sentence }
    deleted_at { nil }

    trait :popular do
      transient do
        count { 10 }
      end

      visibility { 1 }
      created_at { 2.months.ago }

      after(:create) do |playlist, evaluator|
        playlist.playlist_songs << create_list(:playlist_song, evaluator.count, playlist:)
        playlist.reactions << create_list(:reaction, evaluator.count, :liked, playlist:)
      end
    end

    transient do
      likes_count { 0 }
      dislikes_count { 0 }
    end

    trait :featured do
      featured { true }
    end

    trait :not_featured do
      featured { false }
    end

    after(:create) do |playlist, evaluator|
      create_list(:reaction, evaluator.likes_count, :liked, playlist:)
      create_list(:reaction, evaluator.dislikes_count, :disliked, playlist:)
    end

    factory :playlist_with_songs do
      transient do
        count { 0 }
      end

      after(:create) do |playlist, evaluator|
        playlist.playlist_songs << create_list(:playlist_song, evaluator.count, playlist:)
      end
    end

    trait :with_songs do
      transient do
        songs_count { 2 }
      end
    end

    transient do
      songs_count { 0 }
    end

    after(:create) do |_playlist, evaluator|
      create_list(:playlist_song, evaluator.songs_count)
    end
  end
end
