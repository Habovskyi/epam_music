FactoryBot.define do
  factory :album do
    title { ActiveSupport::Inflector.transliterate(FFaker::Music.album) }
  end
end
