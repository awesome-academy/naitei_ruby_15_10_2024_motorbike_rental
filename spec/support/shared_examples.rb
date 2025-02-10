RSpec.shared_examples "guest user redirection" do
  it "redirects to the login page" do
    expect(response).to redirect_to("/users/sign_in")
    expect(flash["alert"]).to eq(I18n.t("devise.failure.unauthenticated"))
  end
end
