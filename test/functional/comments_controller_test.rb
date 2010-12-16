require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  fixtures :all
  
  setup do
    @comment = comments(:one)
    @posting = postings(:one)
<<<<<<< HEAD:test/functional/comments_controller_test.rb
=======
    @episode = episodes(:one)
>>>>>>> 5519a7a30f020a37f9b43a3f30b79711b3405a1d:test/functional/comments_controller_test.rb
    @user    = users(:one)
  end

  test "should get no index without commentable" do
    get :index
    assert_redirected_to root_url
  end

<<<<<<< HEAD:test/functional/comments_controller_test.rb
  test "should get new when logged in" do
     new_user_posting_url(@user,@posting)
=======
  test "should get new for posting when logged in" do
     new_user_posting_comment_url(@user,@posting)
     assert_response :success
  end
  
  test "should get new for episode when logged in" do
     new_user_episode_comment_url(@user,@episode)
>>>>>>> 5519a7a30f020a37f9b43a3f30b79711b3405a1d:test/functional/comments_controller_test.rb
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
