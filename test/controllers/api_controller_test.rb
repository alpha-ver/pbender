require 'test_helper'

class ApiControllerTest < ActionController::TestCase
  test "should get add_field" do
    get :add_field
    assert_response :success
  end

end
