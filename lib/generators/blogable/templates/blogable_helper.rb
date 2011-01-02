module <%= @resource_plural.camelize -%>Helper

  include ActsAsTaggableOn::TagsHelper
  
  # link to show other postings of this user
  def link_to_user_<%= @resource_plural.underscore -%>(<%= @resource_single.underscore -%>)
    <%= @resource_single.underscore -%>.user ? \
      link_to( <%= @resource_single.underscore -%>.user.nickname || <%= @resource_single.underscore -%>.user.email,user_<%= @resource_plural.underscore -%>_path(<%= @resource_single.underscore -%>.user), 
      :title => t(:show_all_users_<%= @resource_plural.underscore -%>)) \
      : t(:anonymous)
  end
  
end
