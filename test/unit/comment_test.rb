require 'test_helper'

class CommentTest < ActiveSupport::TestCase
<<<<<<< HEAD:test/unit/comment_test.rb
    
=======
        
>>>>>>> 5519a7a30f020a37f9b43a3f30b79711b3405a1d:test/unit/comment_test.rb
   def setup
     @user  = User.first || create_valid_user_with_id(1)
   end
  
<<<<<<< HEAD:test/unit/comment_test.rb
=======
   ### General
>>>>>>> 5519a7a30f020a37f9b43a3f30b79711b3405a1d:test/unit/comment_test.rb
   test "Comment should not save without an email" do
     comment = Comment.new
     assert !comment.save, "Comment saved without email"
   end

<<<<<<< HEAD:test/unit/comment_test.rb
   test "Comment should not save without a comment" do
     
     posting = create_valid_posting(@user)
     comment = Comment.new(:user => @user, :commentable => posting)
     assert !comment.save, "Comment saved without body" 
   end

   test "Comment should not save without a valid user" do
     
     posting = create_valid_posting(@user)
     comment = Comment.new(:commentable => posting, :comment => 'A long enough comment.')
     assert !comment.save, "Comment saved without valid user" 
   end

   test "Comment should save with valid user and comment" do
     
     posting = create_valid_posting(@user)
     comment = Comment.new(:user => @user, :commentable => posting, :comment => 'A long enough comment.', :email => @user.email)
     assert comment.save, "Comment not saved #{comment.errors.to_s}"
   end
   
=======
   ### Posting
   test "Comment (for posting) should not save without a comment" do
     posting = create_valid_posting(@user)
     comment = Comment.new(:user => @user, :commentable => posting)
     assert !comment.save, "Comment (for Posting) saved without body" 
   end

   test "Comment (for posting) should not save without a valid user" do
     posting = create_valid_posting(@user)
     comment = Comment.new(:commentable => posting, :comment => 'A long enough comment.')
     assert !comment.save, "Comment (for Posting) saved without valid user" 
   end

   test "Comment (for posting) should save with valid user and comment" do
     posting = create_valid_posting(@user)
     comment = Comment.new(:user => @user, :commentable => posting, :comment => 'A long enough comment.', :email => @user.email)
     assert comment.save, "Comment (for Posting) not saved #{comment.errors.to_s}"
   end
   
   ### Episodes
   test "Comment (for episode) should not save without a comment" do
     episode = create_valid_episode(@user)
     comment = Comment.new(:user => @user, :commentable => episode)
     assert !comment.save, "Comment (for Episode) saved without body" 
   end
   
   test "Comment (for episode) should not save without a valid user" do
     episode = create_valid_episode(@user)
     comment = Comment.new(:commentable => episode, :comment => 'A long enough comment.')
     assert !comment.save, "Comment (for Episode) saved without valid user" 
   end
   
   test "Comment (for episode) should save with valid user and comment" do
     episode = create_valid_episode(@user)
     comment = Comment.new(:user => @user, :commentable => episode, :comment => 'A long enough comment.', :email => @user.email)
     assert comment.save, "Comment (for Episode) not saved #{comment.errors.to_s}"
   end

   
>>>>>>> 5519a7a30f020a37f9b43a3f30b79711b3405a1d:test/unit/comment_test.rb
end
