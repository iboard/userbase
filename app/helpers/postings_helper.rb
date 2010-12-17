module PostingsHelper

  include ActsAsTaggableOn::TagsHelper
  
  # link to show other postings of this user
  def link_to_user_postings(posting)
    posting.user ? \
      link_to( posting.user.nickname || posting.user.email,user_postings_path(posting.user), 
      :title => t(:show_all_users_postings)) \
      : t(:anonymous)
  end

  # link to all postings with this tag
  def insert_tag_list(list)
    unless list.empty?
      "[" +
      list.map { |tag| 
        link_to( tag, tag_postings_path(tag) )
      }.join(", ").html_safe +
      "]"
    else
      ""
    end
  end
  
end
