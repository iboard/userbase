module GalleriesHelper

  include ActsAsTaggableOn::TagsHelper
  
  # link to show other postings of this user
  def link_to_user_galleries(gallery)
    gallery.user ? \
      link_to( gallery.user.nickname || gallery.user.email,user_galleries_path(gallery.user), 
      :title => t(:show_all_users_galleries)) \
      : t(:anonymous)
  end
  
end
