module CommentsHelper
  def comments_hidden?
    @comments_hidden ||= APPLICATION_CONFIG['hide_comments'] == 'true'    
  end
end
