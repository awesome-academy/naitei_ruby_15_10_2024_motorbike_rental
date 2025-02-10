require "rails_helper"

RSpec.describe Admin::RentalsController, type: :controller do
  let(:user) { create(:user, :admin) }
  let(:rental) { create(:rental) }

  before do
    sign_in user
  end

  describe "GET #index" do
    before { get :index }

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "assigns @rentals" do
      expect(assigns(:rentals)).to be_a(ActiveRecord::Relation)
    end

    it "paginates results" do
      expect(assigns(:pagy)).to be_a(Pagy)
    end
  end

  describe "GET #show" do
    context "when rental exists" do
      before { get :show, params: { id: rental.id } }

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "assigns @rental" do
        expect(assigns(:rental)).to eq(rental)
      end
    end

    context "when rental does not exist" do
      before { get :show, params: { id: "invalid" } }

      it "redirects to index" do
        expect(response).to redirect_to(admin_rentals_path)
      end

      it "sets flash error message" do
        expect(flash[:error]).to be_present
      end
    end
  end

  describe "PATCH #approve" do
    context "when rental is pending" do
      let(:rental) { create(:rental, status: :pending) }

      it "approves the rental" do
        expect do
          patch :approve, params: { id: rental.id }
        end.to change { rental.reload.status }.from("pending").to("approved")
      end

      it "sends approval email" do
        expect do
          patch :approve, params: { id: rental.id }
        end.to have_enqueued_mail(RentalMailer, :approval_email)
      end

      it "redirects with success notice" do
        patch :approve, params: { id: rental.id }
        expect(response).to redirect_to(admin_rental_path(rental))
        expect(flash[:notice]).to be_present
      end
    end

    context "when rental is not pending" do
      let(:rental) { create(:rental, status: :approved) }

      it "does not change rental status" do
        expect do
          patch :approve, params: { id: rental.id }
        end.not_to(change { rental.reload.status })
      end

      it "redirects with alert" do
        patch :approve, params: { id: rental.id }
        expect(response).to redirect_to(admin_rental_path(rental))
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe "PATCH #reject" do
    context "when rental is pending and decline reason is present" do
      let(:rental) { create(:rental, status: :pending) }
      let(:decline_reason) { "Not available" }

      it "rejects the rental" do
        expect do
          patch :reject, params: { id: rental.id, decline_reason: decline_reason }
        end.to change { rental.reload.status }.from("pending").to("rejected")
      end

      it "sets decline reason" do
        patch :reject, params: { id: rental.id, decline_reason: decline_reason }
        expect(rental.reload.decline_reason).to eq(decline_reason)
      end

      it "sends rejection email" do
        expect do
          patch :reject, params: { id: rental.id, decline_reason: decline_reason }
        end.to have_enqueued_mail(RentalMailer, :rejection_email)
      end
    end

    context "when rental is not pending or decline reason is missing" do
      let(:rental) { create(:rental, status: :approved) }

      it "does not change rental status" do
        expect do
          patch :reject, params: { id: rental.id }
        end.not_to(change { rental.reload.status })
      end

      it "redirects with alert" do
        patch :reject, params: { id: rental.id }
        expect(response).to redirect_to(admin_rental_path(rental))
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe "PATCH #rent" do
    context "when rental can be rented" do
      let(:rental) { create(:rental, status: :approved) }
      before do
        allow_any_instance_of(Rental).to receive(:can_rent?).and_return(true)
      end
      it "updates status to renting" do
        expect do
          patch :rent, params: { id: rental.id }
        end.to change { rental.reload.status }.to("renting")
      end

      it "redirects with success notice" do
        patch :rent, params: { id: rental.id }
        expect(response).to redirect_to(admin_rental_path(rental))
        expect(flash[:notice]).to be_present
      end
    end

    context "when rental cannot be rented" do
      let(:rental) { create(:rental, status: :pending) }
      before { allow(rental).to receive(:can_rent?).and_return(false) }

      it "does not change rental status" do
        expect do
          patch :rent, params: { id: rental.id }
        end.not_to(change { rental.reload.status })
      end

      it "redirects with alert" do
        patch :rent, params: { id: rental.id }
        expect(response).to redirect_to(admin_rental_path(rental))
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe "PATCH #return" do
    let(:start_datetime) { Time.current - 2.days }
    let(:end_datetime) { Time.current + 1.day }
    let(:rental) do
      create(:rental, status: :renting, start_datetime: start_datetime, end_datetime: end_datetime, total_price: 300)
    end

    context "when rental is renting" do
      it "updates return_datetime" do
        expect do
          patch :return, params: { id: rental.id }
        end.to(change { rental.reload.return_datetime })
      end

      it "updates total_price based on actual duration" do
        patch :return, params: { id: rental.id }
        expect(rental.reload.total_price).not_to eq(300)
      end

      it "updates status to returned" do
        expect do
          patch :return, params: { id: rental.id }
        end.to change { rental.reload.status }.from("renting").to("returned")
      end

      it "redirects with success notice" do
        patch :return, params: { id: rental.id }
        expect(response).to redirect_to(admin_rental_path(rental))
        expect(flash[:notice]).to be_present
      end
    end

    context "when rental is not renting" do
      let(:rental) { create(:rental, status: :approved) }

      it "does not update rental" do
        expect do
          patch :return, params: { id: rental.id }
        end.not_to(change { rental.reload.attributes })
      end

      it "redirects with alert" do
        patch :return, params: { id: rental.id }
        expect(response).to redirect_to(admin_rental_path(rental))
        expect(flash[:alert]).to be_present
      end
    end
  end
end
