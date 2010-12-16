require 'test_helper'

class EpisodeTest < ActiveSupport::TestCase
  fixtures :episodes
  
  # Replace this with your real tests.
  test "Episode should not save without a title" do
    episode = Episode.new
    assert !episode.save, "Episode saved without title"
  end
  
  test "Episode should not save without a description" do
    episode = Episode.new(:title => 'My Episode')
    assert !episode.save, "Episode saved without description" 
  end
  
  test "Episode should not save without an user (author)" do
    episode = Episode.new(:title => 'My Episode', :description => 'My beautyfull episode')
    assert !episode.save, "Episode saved without user" 
  end
  
  test "Episode should save with title, body, and user" do
    user = create_valid_user_with_id(1)
    episode = Episode.new(:title => 'My Episode', :description => 'My beautyfull episode', :user_id => 1)
    assert episode.save, "Episode saved without user" 
  end
  
  test "Episode should not save if user not exists" do
    episode = Episode.new(:title => 'My Episode', :description => 'My beautyfull episode', :user_id => 9999)
    assert !episode.save, "Episode saved with not existing user" 
  end
  
  test "YouTubeVideo should be identifyed with is_youtube_video?" do
    assert episodes(:youtube).is_youtube_video?, "Fixture :youtube should return true on is_youtube_video?"
  end
  
end
