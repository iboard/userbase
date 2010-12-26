require 'test_helper'

class EpisodesControllerTest < ActionController::TestCase
  include Devise::TestHelpers  
  fixtures :all

  setup do
    @episode = episodes(:one)
  end


end
