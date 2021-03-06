module ApplicationHelper
  include LayoutHelper
  include SpecialCharacters
  
  def main_menu_items
    if File::exist?(menu_file = File::join(Rails.root,'config','main_menu_items.rb'))
      code  = File.new(menu_file).read
      eval code
    else
      menu_items =  [ {:label => t(:blog), :url => root_path } ]
      menu_items << { :label => t(:postings), :url => postings_path }  if can?( :read, Posting ) 
      menu_items << { :label => 'Videos', :url => episodes_path }  if can?( :read, Episode )
      menu_items += [
        {:label => t(:legal_notice), :url => legal_notice_path},
        {:label => t(:about), :url => about_path }
      ]
    end
    menu_items
  end
  
  def admin_menu_items
    if File::exist?(menu_file = File::join(Rails.root,'config','admin_menu_items.rb'))
      code  = File.new(menu_file).read
      eval code
    else
      menu_items = []
      menu_items  << { :label => t(:edit_static_pages), :url => static_pages_path } if current_user && current_user.role?(:admin)
#      menu_items  << { :label => t(:subscriptions), :url => user_subscriptions_path(current_user)} if current_user
      menu_items  << { :label => t(:user_listing), :url => users_path } if current_user && can?( :read, User.new )
      menu_items  << { :label => t(:user), :url => user_settings_path(current_user) } if current_user && can?(:avatar, current_user)
      menu_items
    end
  end
  
  def button(content)
    content_tag :div, :class => 'link_button' do
      content
    end
  end

  def right_button(content)
    content_tag :div, :class => 'right_button' do
      content
    end
  end

  def title_buttons(content)
    content_tag :div, :class => 'title_buttons' do
      content
    end
  end

  def inline_button(content)
    content_tag :span, :class => 'inline_button' do
      content
    end
  end
  
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + "&nbsp;".html_safe + link_to_function(name,"remove_fields(this)")
  end
  
  def link_to_add_fields(name,f,association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields  = f.fields_for(association,new_object, :child_index=>"new_#{association}") do |builder|
      render(association.to_s.pluralize+"/"+association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name,"add_fields(this,\"#{association}\", \"#{escape_javascript(fields)}\")")
  end
  
  def link_to_toggle(name,target)
    link_to_function(name,"$(\"##{target}\").slideToggle()")
  end
    
  def language_filter
    
    # If no filter is defined - set all languages selected
    session[:language_filter] ||= []
    if session[:language_filter].blank?
      session[:language_filter] = I18n.available_locales.map { |x| x.to_s }
    end
    
    rc = I18n.available_locales.map { |l| 
      unless session[:language_filter].include?(l.to_s)
        link_to( t("locales.#{l.to_s}".to_sym), 
                     set_language_filter_path(l.to_s), :remote => true,
                     :title => t(:help_language_filter)
               )+sc(:nbsp,:failed).html_safe
      else
        link_to( t("locales.#{l.to_s}".to_sym), 
                     set_language_filter_path(l.to_s), :remote => true,
                     :title => t(:help_language_filter)
               )+sc(:nbsp,:ok).html_safe
      end
    }.join(", ") +
    "<p class='language_filter_help'>#{t(:language_filter_help)}</p>"
    return rc.html_safe
  end
  
  
  def rating_links( item, user)
    item_ratings_avg = item.ratings_average || 0
    item_ratings_count=item.ratings_count || 0
    my_rating         = user.ratings.where(:rateable_id => item.id, :rateable_type => item.class.to_s).first  if user
      
    content_tag :div, :id => "rating_#{item.id}", :class=>'rating' do
      rc = ""
      for i in eval(CONSTANTS['rating_range'])
        # always link to rate if user
        img_url = item_ratings_avg >= i ? "rating_1" : "rating_0"
        label_text = user.nil? ? t(:please_log_in_to_rate) : t(:click_to_rate)
        if user
          rc += link_to( image_tag( "/images/#{img_url}.png", :title => label_text  ),
                        rate_path(user,item,item.class.to_s,i),
                        :remote => true
                       )
        else
          rc += image_tag( "/images/#{img_url}.png", 
                           :title => label_text )
        end
      end
      rc += sc(:br)+t(:count_ratings, :count => item_ratings_count, :rating => item_ratings_avg)
      rc += sc(:nbsp)*2+t(:ratings_average, :count => item_ratings_avg, :rating => item_ratings_avg)
      rc += sc(:nbsp)*2+t(:you) + sc(:nbsp,:pr,:nbsp) + my_rating.rating.to_s if user && my_rating
      rc.html_safe
    end
  end
  
  private
  def show_selected_languages
    session[:language_filter].blank? ? t(:all) : "#{session[:language_filter].join(',') unless session[:language_filter].blank?}"
  end
  
end
