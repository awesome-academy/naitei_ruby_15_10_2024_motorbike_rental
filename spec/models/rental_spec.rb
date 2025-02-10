require "rails_helper"

RSpec.describe Rental, type: :model do
  let(:user) { create(:user) }
  let(:rental) { create(:rental, user: user) }

  describe "associations" do
    it { should belong_to(:user) }
    it { should have_many(:rental_vehicles).dependent(:destroy) }
    it { should have_many(:proofs).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:phone_number) }
    it { should validate_presence_of(:delivery_location) }
    it { should validate_presence_of(:start_datetime) }
    it { should validate_presence_of(:end_datetime) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:total_price) }

    context "when status is rejected" do
      before { rental.status = :rejected }

      it "validates presence of decline_reason" do
        rental.decline_reason = nil
        expect(rental).not_to be_valid
        expect(rental.errors[:decline_reason]).to include("can't be blank")
      end
    end
  end

  describe "scopes" do
    describe ".by_user" do
      it "returns rentals for the given user" do
        rental1 = create(:rental, user: user)
        rental2 = create(:rental)
        expect(Rental.by_user(user.id)).to include(rental1)
        expect(Rental.by_user(user.id)).not_to include(rental2)
      end
    end

    describe ".overdue" do
      it "returns overdue rentals" do
        overdue_rental = create(:rental, end_datetime: 2.days.ago, status: :approved)
        returned_rental = create(:rental, end_datetime: 2.days.ago, status: :returned)

        expect(Rental.overdue).to include(overdue_rental)
        expect(Rental.overdue).not_to include(returned_rental)
      end
    end
  end

  describe "enums" do
    it {
      should define_enum_for(:status).with_values(pending: 0, approved: 1, rejected: 2, canceled: 3, renting: 4,
                                                  returned: 5)
    }

    context "status enum behavior" do
      it "has correct status values" do
        expect(Rental.statuses).to eq({
                                        "pending" => 0,
                                        "approved" => 1,
                                        "rejected" => 2,
                                        "canceled" => 3,
                                        "renting" => 4,
                                        "returned" => 5
                                      })
      end

      it "allows setting status with symbols" do
        rental.update(status: :approved)
        expect(rental.status).to eq("approved")
        expect(rental.approved?).to be true
      end

      it "allows setting status with integers" do
        rental.update(status: 4)
        expect(rental.status).to eq("renting")
        expect(rental.renting?).to be true
      end

      it "returns rentals by status scope" do
        pending_rental = create(:rental, status: :pending)
        renting_rental = create(:rental, status: :renting)

        expect(Rental.pending).to include(pending_rental)
        expect(Rental.renting).to include(renting_rental)
        expect(Rental.pending).not_to include(renting_rental)
      end
    end
  end

  describe "instance methods" do
    describe "#overdue?" do
      it "returns true if rental is overdue" do
        rental.end_datetime = 1.day.ago
        rental.status = :approved
        expect(rental.overdue?).to be_truthy
      end

      it "returns false if rental is returned" do
        rental.end_datetime = 1.day.ago
        rental.status = :returned
        expect(rental.overdue?).to be_falsey
      end
    end

    describe "#cancellable?" do
      it "returns true if rental is pending" do
        rental.status = :pending
        expect(rental.cancellable?).to be_truthy
      end

      it "returns false if rental is approved or rejected" do
        rental.status = :approved
        expect(rental.cancellable?).to be_falsey

        rental.status = :rejected
        expect(rental.cancellable?).to be_falsey
      end
    end

    describe "#can_rent?" do
      it "returns true if approved and has proofs" do
        rental.status = :approved
        create(:proof, user: user, rental: rental)
        expect(rental.can_rent?).to be_truthy
      end

      it "returns false if not approved or no proofs" do
        rental.status = :pending
        expect(rental.can_rent?).to be_falsey
      end
    end
  end
end
