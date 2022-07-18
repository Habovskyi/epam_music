FactoryBot.define do
  factory :song do
    author { Author.take || create(:author) }
    album { create(:album) }
    genre { Genre.take || create(:genre) }
    sequence(:title) { |n| "AB#{n}" }
    featured { FFaker::Boolean.random }
    count_listening { FFaker::Random.rand }
  end
end
