require 'test_helper'

class BlogControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  fixtures :all
  
  setup do
    @comment = comments(:one)
    @posting = postings(:one)
    @episode = episodes(:one)
    @user    = users(:one)
    BlogEntry.create(:blog_entry_id => @posting.id, :blog_entry_type => 'Posting')
    BlogEntry.create(:blog_entry_id => @episode.id, :blog_entry_type => 'Episode')
  end


  test "should get index" do
    get :index
    assert_response :success
  end

end
