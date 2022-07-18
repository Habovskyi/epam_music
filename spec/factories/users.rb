FactoryBot.define do
  factory :user do
    username do
      FFaker::Internet.unique
                      .user_name
                      .ljust(
                        Api::V1::Users::BaseForm::USERNAME_MIN_LENGTH,
                        'a'
                      )[0...Api::V1::Users::BaseForm::USERNAME_MAX_LENGTH]
    end
    email { FFaker::Internet.unique.safe_email }
    password do
      "#{FFaker::Internet.password(
        Api::V1::Users::BaseForm::PASSWORD_MIN_LENGTH - 3, Api::V1::Users::BaseForm::PASSWORD_MAX_LENGTH - 3
      )}@aA"
    end
    password_confirmation { password }
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    playlists_created { 0 }
    active { true }

    factory :user_with_avatar do
      avatar { Rack::Test::UploadedFile.new('spec/fixtures/avatar/test_avatar.png', 'image/png') }
    end

    factory :invalid_user do
      username { 'badU$$ername' }
      email { 'bad@eee@mail.com' }
      password { 'weakpassword' }
      first_name { 'J' }
      last_name { 'Butch3r' }
    end

    trait :user_with_predefined_emails do
      sequence(:email) { |n| "person#{n}@example.com" }
    end

    trait :inactive do
      active { false }
    end

    trait :best_contributor do
      playlists_created { 30 }
    end
  end
end
