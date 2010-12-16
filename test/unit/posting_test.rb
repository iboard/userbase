require 'test_helper'

class PostingTest < ActiveSupport::TestCase

  # check that posting can not be saved with missing information

  test "Posting should not save without a title" do
    posting = Posting.new
    assert !posting.save, "Posting saved without title"
  end
  
  test "Posting should not save without a body" do
    posting = Posting.new(:title => 'My Posting')
    assert !posting.save, "Posting saved without body" 
  end
  
  test "Posting should not save without an user (author)" do
    posting = Posting.new(:title => 'My Posting', :body => 'My beautyfull body')
    assert !posting.save, "Posting saved without user" 
  end
    
  test "Posting should not save if user not exists" do
    posting = Posting.new(:title => 'My Posting', :body => 'My beautyfull body', :user_id => 9999)
    assert !posting.save, "Posting saved with not existing user" 
  end
  
  test "Posting should save with title, body, and user" do
    user = create_valid_user_with_id(1)
    posting = Posting.new(:title => 'My Posting', :body => 'My beautyfull body', :user_id => 1)
    assert posting.save, "Posting saved without user" 
  end
  
<<<<<<< HEAD:test/unit/posting_test.rb
  
  test "Posting should not saved when access masks are zero" do
    
=======
  test "Posting should not saved when access masks are zero" do
    user = create_valid_user_with_id(1)
    posting = Posting.new(:title => 'My Posting', :body => 'My beautyfull body', :user_id => 1,
                          :access_read_mask => 0,
                          :access_manage_mask => 0
                          )
    assert !posting.save, "Posting saved with 0-access_masks"
>>>>>>> 5519a7a30f020a37f9b43a3f30b79711b3405a1d:test/unit/posting_test.rb
  end

  # check if posting can be saved when complete

  test "Posting should save with title, body, user when valid?" do
    user = create_valid_user_with_id(1)
    posting = Posting.new(:title => 'My Posting', :body => 'My beautyfull body', :user_id => user.to_param)
    assert posting.save, "Posting could not be saved" 
    assert posting.valid?, "Posting is invalid"
  end  
end
