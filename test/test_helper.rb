ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  
  ##fixtures :all

  # Add more helper methods to be used by all tests here...
  
  def create_valid_user_with_id(id)
    user = User.new(
                    :id => id, :email => 'tester@test.te', :nickname => 'nockenfell',
                    :password => 'secret', :password_confirmation => 'secret'
                   )
    user.save!
    user
  end
  
  def create_valid_posting(user)
    posting = Posting.new(:user => user, :title => 'My Posting', :body => 'My Body')
    posting.save!
    posting
  end
  
  
<<<<<<< HEAD:test/test_helper.rb
=======
  def create_valid_episode(user)
    episode = Episode.new(:user => user, :title => 'My Posting', :description => 'My Description')
    episode.save!
    episode
  end
  
>>>>>>> 5519a7a30f020a37f9b43a3f30b79711b3405a1d:test/test_helper.rb
  
  
end
