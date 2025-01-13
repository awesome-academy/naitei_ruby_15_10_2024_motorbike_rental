User.destroy_all
Brand.destroy_all
Model.destroy_all
VehicleDetail.destroy_all

User.create!(
  name: "Admin User",
  email: "pqnad@gmail.com",
  password: "123456",
  password_confirmation: "123456",
  role: :admin,
  status: :active,
  phone_number: "0932417536"
)

User.create!(
  name: "Normal User",
  email: "pqn@gmail.com",
  password: "123456",
  password_confirmation: "123456",
  role: :user,
  status: :active,
  phone_number: "0932417534"
)

User.create!(
  name: "Normal User",
  email: "pqn2@gmail.com",
  password: "123456",
  password_confirmation: "123456",
  role: :user,
  status: :active,
  phone_number: "0932417535"
)

brands_and_models = [
  {
    name: "Honda",
    models: [
      { name: "Air Blade", engine_capacity: :from_50_to_100cc, vehicle_type: :scooter, price_per_day: 120_000 },
      { name: "Click", engine_capacity: :from_50_to_100cc, vehicle_type: :scooter, price_per_day: 110_000 },
      { name: "Lead", engine_capacity: :from_100_to_175cc, vehicle_type: :scooter, price_per_day: 150_000 },
      { name: "PCX", engine_capacity: :from_100_to_175cc, vehicle_type: :scooter, price_per_day: 180_000 },
      { name: "SH", engine_capacity: :from_100_to_175cc, vehicle_type: :scooter, price_per_day: 200_000 },
      { name: "SH Mode", engine_capacity: :from_100_to_175cc, vehicle_type: :scooter, price_per_day: 220_000 },
      { name: "Wave", engine_capacity: :from_50_to_100cc, vehicle_type: :manual, price_per_day: 100_000 },
      { name: "Winner", engine_capacity: :over_175cc, vehicle_type: :moto, price_per_day: 250_000 },
      { name: "Winner X", engine_capacity: :over_175cc, vehicle_type: :moto, price_per_day: 300_000 },
      { name: "Vision", engine_capacity: :from_50_to_100cc, vehicle_type: :scooter, price_per_day: 130_000 }
    ]
  },
  {
    name: "Yamaha",
    models: [
      { name: "Exciter", engine_capacity: :from_100_to_175cc, vehicle_type: :manual, price_per_day: 120_000 },
      { name: "Sirius", engine_capacity: :from_50_to_100cc, vehicle_type: :manual, price_per_day: 100_000 },
      { name: "NVX", engine_capacity: :from_100_to_175cc, vehicle_type: :scooter, price_per_day: 160_000 },
      { name: "Grande", engine_capacity: :from_100_to_175cc, vehicle_type: :scooter, price_per_day: 170_000 }
    ]
  },
  {
    name: "SYM",
    models: [
      { name: "Attila", engine_capacity: :from_50_to_100cc, vehicle_type: :scooter, price_per_day: 110_000 },
      { name: "Jet 14", engine_capacity: :from_100_to_175cc, vehicle_type: :scooter, price_per_day: 140_000 },
      { name: "Sport", engine_capacity: :from_100_to_175cc, vehicle_type: :manual, price_per_day: 130_000 },
      { name: "Maxsym", engine_capacity: :over_175cc, vehicle_type: :scooter, price_per_day: 210_000 }
    ]
  },
  {
    name: "Piaggio",
    models: [
      { name: "Liberty", engine_capacity: :from_50_to_100cc, vehicle_type: :scooter, price_per_day: 120_000 },
      { name: "Vespa", engine_capacity: :from_50_to_100cc, vehicle_type: :scooter, price_per_day: 180_000 },
      { name: "Beverly", engine_capacity: :from_100_to_175cc, vehicle_type: :scooter, price_per_day: 160_000 },
      { name: "GTS", engine_capacity: :from_100_to_175cc, vehicle_type: :scooter, price_per_day: 190_000 }
    ]
  }
]

def generate_license_plate
  first_part = "#{rand(10..99)}#{('A'..'Z').to_a.sample}#{rand(0..9)}"
  second_part = rand(1000..9999)
  "#{first_part} - #{second_part}"
end

brands_and_models.each do |brand_data|
  brand = Brand.create!(name: brand_data[:name])

  brand_data[:models].each do |model_data|
    model = Model.create!(
      name: model_data[:name],
      brand: brand,
      price_per_day: model_data[:price_per_day],
      vehicle_type: model_data[:vehicle_type],
      engine_capacity: model_data[:engine_capacity]
    )

    model_images_path = Rails.root.join("db", "SeedImage", brand.name, model_data[:name])

    next unless Dir.exist?(model_images_path) && Dir.entries(model_images_path).reject do |entry|
      entry.start_with?(".")
    end.any?

    model_images = Dir.entries(model_images_path).reject { |entry| entry.start_with?(".") }

    model_images.each_with_index do |image_name, i|
      image_path = model_images_path.join(image_name)

      vehicle_detail = VehicleDetail.create!(
        model: model,
        number: generate_license_plate,
        available: true,
        color: %w[Red Black White Blue Silver].sample
      )

      vehicle_detail.image.attach(io: File.open(image_path), filename: "#{model.name}-#{i + 1}.jpg",
                                  content_type: "image/jpeg")
    end
  end
end

puts "Created #{Brand.count} brands"
puts "Created #{Model.count} models"
puts "Created #{VehicleDetail.count} vehicle details"
users = User.where(role: :user)
vehicles = VehicleDetail.all
statuses = Rental.statuses.keys.reject { |status| status == "rejected" }
users.each do |user|
  vehicles.sample(5).each do |vehicle|
    rental = if rand < 0.3
               Rental.create!(
                 user: user,
                 name: Faker::Name.name,
                 phone_number: Faker::PhoneNumber.cell_phone_in_e164,
                 delivery_location: "#{Faker::Address.building_number} #{Faker::Address.street_name}, Đà Nẵng",
                 start_datetime: rand(1..7).days.ago,
                 end_datetime: rand(1..7).days.ago,
                 status: "renting",
                 total_price: vehicle.price_per_day * rand(1..10)
               )
             else
               Rental.create!(
                 user: user,
                 name: Faker::Name.name,
                 phone_number: Faker::PhoneNumber.cell_phone_in_e164,
                 delivery_location: "#{Faker::Address.building_number} #{Faker::Address.street_name}, Đà Nẵng",
                 start_datetime: rand(1..30).days.ago,
                 end_datetime: rand(1..30).days.from_now,
                 status: statuses.sample,
                 total_price: vehicle.price_per_day * rand(1..10)
               )
             end

    RentalVehicle.create!(
      rental: rental,
      vehicle_detail: vehicle
    )
  end
end

puts "Created #{Rental.count} rentals"
