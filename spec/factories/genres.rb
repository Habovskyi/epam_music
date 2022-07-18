FactoryBot.define do
  factory :genre do
    sequence(:name) { |n| FFaker::Music::GENRES[n % FFaker::Music::GENRES.length] }
  end
end
