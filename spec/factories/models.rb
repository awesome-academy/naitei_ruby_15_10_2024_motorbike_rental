FactoryBot.define do
  factory :model do
    brand
    sequence(:name) { |n| "Model #{n}" }
    price_per_day { rand(10_000..100_000) }
    vehicle_type { Model.vehicle_types.keys.sample }
    engine_capacity { Model.engine_capacities.keys.sample }

    trait :scooter do
      vehicle_type { :scooter }
      engine_capacity { :under_50cc }
    end

    trait :manual do
      vehicle_type { :manual }
      engine_capacity { :from_50_to_100cc }
    end

    trait :moto do
      vehicle_type { :moto }
      engine_capacity { :over_175cc }
    end

    trait :with_vehicles do
      transient do
        vehicles_count { 2 }
      end

      after(:create) do |model, evaluator|
        create_list(:vehicle_detail, evaluator.vehicles_count, model: model)
      end
    end
  end
end
