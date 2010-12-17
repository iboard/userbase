module ApplicationHelper
  include LayoutHelper
  include SpecialCharacters
  
  def main_menu_items
    menu_items =  [ {:label => t(:home), :url => root_path } ]
    menu_items << { :label => t(:postings), :url => postings_path }  if can?( :read, Posting ) 
    menu_items << { :label => 'Videos', :url => episodes_path }  if can?( :read, Episode )
    menu_items += [
      {:label => t(:legal_notice), :url => legal_notice_path},
      {:label => t(:about), :url => about_path }
    ]
    menu_items
  end
  
  def admin_menu_items
      menu_items = []
      menu_items  << { :label => t(:user_listing), :url => users_path } if current_user && can?( :read, User )
      menu_items  << { :label => t(:user), :url => user_settings_path(current_user) } if current_user && can?(:avatar, current_user)
      menu_items
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
  
  private
  def show_selected_languages
    session[:language_filter].blank? ? t(:all) : "#{session[:language_filter].join(',') unless session[:language_filter].blank?}"
  end
  
end
