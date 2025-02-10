FactoryBot.define do
  factory :vehicle_detail do
    rental_vehicle
    model
    sequence(:number) { |n| "VIN#{n}" }
    color { %w[Red Blue Black White Silver].sample }
    available { true }

    after(:build) do |vehicle_detail|
      unless vehicle_detail.image.attached?
        vehicle_detail.image.attach(
          io: File.open(Rails.root.join("spec", "fixtures", "files", "image_3.jpg")),
          filename: "image_3.jpg",
          content_type: "image/jpeg"
        )
      end
    end

    trait :unavailable do
      available { false }
    end

    trait :without_image do
      after(:build) do |vehicle_detail|
        vehicle_detail.image.purge if vehicle_detail.image.attached?
      end
    end
  end
end
