FactoryBot.define do
  factory :admin_user do
    email { FFaker::Internet.unique.safe_email }
    password { FFaker::Internet.password }
    password_confirmation { password }
  end
end
