FactoryBot.define do
  factory :comment do
    association :user, factory: :user
    association :playlist, factory: :playlist
    text { (FFaker::Lorem.sentence).slice(0...Api::V1::Comments::CreateForm::TEXT_MAX_LENGTH) }
  end
end
