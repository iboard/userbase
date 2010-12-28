module PostingsHelper

  include ActsAsTaggableOn::TagsHelper
  
  # link to show other postings of this user
  def link_to_user_postings(posting)
    posting.user ? \
      link_to( posting.user.nickname || posting.user.email,user_postings_path(posting.user), 
      :title => t(:show_all_users_postings)) \
      : t(:anonymous)
  end

  
end
