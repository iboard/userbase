module RatingsHelper
  def ratings_hidden?
    @ratings_hidden ||= APPLICATION_CONFIG['hide_ratings'] == true    
  end
end
