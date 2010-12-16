require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  fixtures :all
  
  setup do
    @comment = comments(:one)
    @posting = postings(:one)
    @episode = episodes(:one)
    @user    = users(:one)
  end

  test "should get no index without commentable" do
    get :index
    assert_redirected_to root_url
  end

  test "should get new for posting when logged in" do
     new_user_posting_comment_url(@user,@posting)
     assert_response :success
  end
  
  test "should get new for episode when logged in" do
     new_user_episode_comment_url(@user,@episode)
     assert_response :success
   end

   test "should create comment for logged in user" do
     # "Create a comment test is covered by cucumber"
     assert true
   end

   test "should destroy comment" do
     # "Destroy a comment test is covered by cucumber"
     assert true
   end
 
end
