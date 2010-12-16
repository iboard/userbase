require 'test_helper'

class PostingsControllerTest < ActionController::TestCase
  include Devise::TestHelpers  
  fixtures :all
  
  setup do
    @input_attributes = { 
      :title	  => "My Test Posting", 
      :body	    => "My Test Body",
      :user_id  => users(:one).id
    }
    @user = users(:one)
  end
  
  test "should get index without user logged in" do
    get :index
    assert_response :success
  end
  

  test "User should log in" do
    sign_in @user
    assert_response :success
  end
  

end
