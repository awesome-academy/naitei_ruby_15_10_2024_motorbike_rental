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
      { name: "Wave Alpha", engine_capacity: :from_50_to_100cc, vehicle_type: :manual, price_per_day: 100000 },
      { name: "Future", engine_capacity: :from_50_to_100cc, vehicle_type: :manual, price_per_day: 120000 },
      { name: "Vision", engine_capacity: :from_50_to_100cc, vehicle_type: :scooter, price_per_day: 150000 },
      { name: "Lead", engine_capacity: :from_100_to_175cc, vehicle_type: :scooter, price_per_day: 180_000 },
      { name: "SH Mode", engine_capacity: :from_100_to_175cc, vehicle_type: :scooter, price_per_day: 200_000 },
      { name: "Winner X", engine_capacity: :over_175cc, vehicle_type: :moto, price_per_day: 300_000 }
    ]
  },
  {
    name: "Yamaha",
    models: [
      { name: "Exciter", engine_capacity: :from_100_to_175cc, vehicle_type: :manual, price_per_day: 180_000 },
      { name: "Sirius", engine_capacity: :from_50_to_100cc, vehicle_type: :manual, price_per_day: 100_000 },
      { name: "NVX", engine_capacity: :from_100_to_175cc, vehicle_type: :scooter, price_per_day: 200_000 },
      { name: "Grande", engine_capacity: :from_100_to_175cc, vehicle_type: :scooter, price_per_day: 220_000 }
    ]
  },
  {
    name: "Suzuki",
    models: [
      { name: "Raider", engine_capacity: :from_100_to_175cc, vehicle_type: :manual, price_per_day: 170_000 },
      { name: "Satria", engine_capacity: :from_100_to_175cc, vehicle_type: :moto, price_per_day: 250_000 },
      { name: "Address", engine_capacity: :from_50_to_100cc, vehicle_type: :scooter, price_per_day: 90_000 }
    ]
  }
]
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
    rand(2..4).times do |i|
      VehicleDetail.create!(
        model: model,
        number: "#{brand.name.upcase}-#{model.name.upcase}-#{i + 1}",
        available: true,
        color: %w[Red Black White Blue Silver].sample
      )
    end
  end
end

puts "Created #{Brand.count} brands"
puts "Created #{Model.count} models"
puts "Created #{VehicleDetail.count} vehicle details"
