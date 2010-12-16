require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  include Devise::TestHelpers  
  fixtures :all
  
  setup do
    @posting_input_attributes = { 
      :title	  => "My Test Posting", 
      :body	    => "My Test Body",
      :user_id  => users(:one).id
    }
    @user = users(:one)
  end
  

end