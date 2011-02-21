class Episode < ActiveRecord::Base

  is_blogable
  
  validates :title,       :presence => true
  validates :description, :presence => true
    
  # Return the description as body for rss-feed (Commentable)
  def body
    description
  end
  
  def is_youtube_video?
    video_web_url.downcase.include?('http://www.youtube.com/')
  end
  
  def youtube_embed_url
    video_web_url.gsub("http://www.youtube.com/watch?v=",
      "http://www.youtube.com/v/"
    )
  end
  
  
  def play_button
    is_youtube_video? ? "youtube_popup('"+youtube_embed_url+"')" : "video_popup('#{video_web_url}','#{video_mobile_url}')"
  end
  
  def num_items
    1
  end
  
  def content
    :video
  end
  
end
