FactoryBot.define do
  factory :reaction do
    association :user
    association :playlist
    reaction_type { %i[liked disliked].sample }

    trait :liked do
      reaction_type { :liked }
    end

    trait :disliked do
      reaction_type { :disliked }
    end
  end
end
