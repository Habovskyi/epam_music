FactoryBot.define do
  factory :friendship do
    association :user_from, factory: :user
    association :user_to, factory: :user

    factory :accepted_friendship, traits: [:accepted]
    factory :declined_friendship, traits: [:declined]
  end
end
