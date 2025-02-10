FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    phone_number { Faker::PhoneNumber.cell_phone_in_e164 }
    password { "Password123!" }
    password_confirmation { "Password123!" }
    role { :customer }
    confirmed_at { Time.current }

    trait :admin do
      role { :admin }
    end

    trait :unconfirmed do
      confirmed_at { nil }
    end
  end
end
