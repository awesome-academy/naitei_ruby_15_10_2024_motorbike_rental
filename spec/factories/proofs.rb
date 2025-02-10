# spec/factories/proofs.rb
FactoryBot.define do
  factory :proof do
    association :user
    association :rental
    name { "Proof Document" }
    storage_type { :original }

    after(:build) do |proof|
      proof.image.attach(
        io: File.open(Rails.root.join("spec", "fixtures", "files", "image_3.jpg")),
        filename: "image_3.jpg",
        content_type: "image/jpeg"
      )
    end
  end
end
