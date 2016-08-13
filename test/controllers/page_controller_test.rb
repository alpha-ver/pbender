require 'test_helper'

class PageControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get about" do
    get :about
    assert_response :success
  end

  test "should get support" do
    get :support
    assert_response :success
  end

  test "should get plugins" do
    get :plugins
    assert_response :success
  end

  test "should get projects" do
    get :projects
    assert_response :success
  end

  test "should get manual" do
    get :manual
    assert_response :success
  end

end
