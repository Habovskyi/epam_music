FactoryBot.define do
  factory :author do
    sequence(:nickname) { |n| ActiveSupport::Inflector.transliterate(FFaker::Music.artist) + n.to_s }
  end
end
