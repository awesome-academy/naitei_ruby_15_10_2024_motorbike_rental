# db/seeds.rb
# Motorcycle Brands and Models in Vietnam

# Clear existing data to prevent duplicates
Brand.destroy_all
Model.destroy_all
VehicleDetail.destroy_all

# Popular Motorcycle Brands in Vietnam with their models and typical engine capacities
brands_and_models = [
  {
    name: "Honda",
    models: [
      { name: "Wave Alpha", engine_capacity: :from_50_to_100cc, vehicle_type: :manual },
      { name: "Future", engine_capacity: :from_50_to_100cc, vehicle_type: :manual },
      { name: "Vision", engine_capacity: :from_50_to_100cc, vehicle_type: :scooter },
      { name: "Lead", engine_capacity: :from_100_to_175cc, vehicle_type: :scooter },
      { name: "SH Mode", engine_capacity: :from_100_to_175cc, vehicle_type: :scooter },
      { name: "Winner X", engine_capacity: :over_175cc, vehicle_type: :moto }
    ]
  },
  {
    name: "Yamaha",
    models: [
      { name: "Exciter", engine_capacity: :from_100_to_175cc, vehicle_type: :manual },
      { name: "Sirius", engine_capacity: :from_50_to_100cc, vehicle_type: :manual },
      { name: "NVX", engine_capacity: :from_100_to_175cc, vehicle_type: :scooter },
      { name: "Grande", engine_capacity: :from_100_to_175cc, vehicle_type: :scooter }
    ]
  },
  {
    name: "Suzuki",
    models: [
      { name: "Raader", engine_capacity: :from_100_to_175cc, vehicle_type: :manual },
      { name: "Satria", engine_capacity: :from_100_to_175cc, vehicle_type: :moto },
      { name: "Address", engine_capacity: :from_50_to_100cc, vehicle_type: :scooter }
    ]
  }
]

# Create brands and their models
brands_and_models.each do |brand_data|
  brand = Brand.create!(name: brand_data[:name])

  brand_data[:models].each do |model_data|
    model = Model.create!(
      name: model_data[:name],
      brand: brand
    )

    # Create multiple vehicle details for each model
    rand(2..4).times do |i|
      VehicleDetail.create!(
        model: model,
        number: "#{brand.name.upcase}-#{model.name.upcase}-#{i + 1}",
        vehicle_type: model_data[:vehicle_type],
        engine_capacity: model_data[:engine_capacity],
        price_per_day: case model_data[:engine_capacity]
                       when :under_50cc then rand(50000..100000)
                       when :from_50_to_100cc then rand(100000..150000)
                       when :from_100_to_175cc then rand(150000..250000)
                       when :over_175cc then rand(250000..400000)
                       else rand(100000..300000)
                       end,
        available: true, # Explicitly set to true instead of using .sample
        color: %w[Red Black White Blue Silver].sample
      )
    end
  end
end

puts "Created #{Brand.count} brands"
puts "Created #{Model.count} models"
puts "Created #{VehicleDetail.count} vehicle details"
