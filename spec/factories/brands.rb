FactoryBot.define do
  factory :brand do
    sequence(:name) { |n| "Brand #{n}" }

    trait :with_models do
      transient do
        models_count { 2 }
      end

      after(:create) do |brand, evaluator|
        create_list(:model, evaluator.models_count, brand: brand)
      end
    end
  end
end
