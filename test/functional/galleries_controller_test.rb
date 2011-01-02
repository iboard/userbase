require 'test_helper'

class GalleriesControllerTest < ActionController::TestCase
  include Devise::TestHelpers  
  fixtures :all

  setup do
    @user    = users(:one)
    @gallery = galleries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:galleries)
  end

end
