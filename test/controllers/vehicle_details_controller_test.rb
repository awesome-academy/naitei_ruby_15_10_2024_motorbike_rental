require "test_helper"

class VehicleDetailsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get vehicle_details_new_url
    assert_response :success
  end
end
