FactoryBot.define do
  factory :rental do
    association :user, factory: :user
    name { Faker::Name.name }
    phone_number { Faker::PhoneNumber.cell_phone }
    delivery_location { Faker::Address.full_address }
    start_datetime { Faker::Time.forward(days: 2, period: :morning) }
    end_datetime { start_datetime + 3.days }
    status { :pending }
    total_price { Faker::Commerce.price(range: 100.0..1000.0) }

    trait :rejected do
      status { :rejected }
      decline_reason { "Không đáp ứng điều kiện cho thuê" }
    end

    trait :approved do
      status { :approved }
    end

    trait :overdue do
      status { :renting }
      end_datetime { 2.days.ago }
    end
  end
end
