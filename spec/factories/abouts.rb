FactoryBot.define do
  factory :about do
    body { FFaker::HTMLIpsum.body }
  end
end
