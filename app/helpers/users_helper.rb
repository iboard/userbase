module UsersHelper
  def user_settings_menu(&block)
     if current_user
       content_tag(:div, :id => 'users_menu') {
          ( can?(:edit,   current_user) ? link_to( t(:user_settings_link), user_settings_path(current_user)) : ""  )      + "<br/>".html_safe +
          ( can?(:avatar, current_user) ? link_to( t(:set_or_change_your_avatar), avatar_user_path(current_user)) : ""  ) + "<br/>".html_safe +
          (block ? yield : "")
       }
     end
   end
   
   def user_avatar(user)
     if user && user.gravatar_profile
       link_to(
                 image_tag( w3c_url(user.avatar_url(:icon)), :class => 'posting_author_icon' ),
                 user.gravatar_profile
               )
     else
       image_tag( w3c_url(user.avatar_url(:icon)), :class => 'posting_author_icon' ) if user
     end
   end
end
