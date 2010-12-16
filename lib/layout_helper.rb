module LayoutHelper
    
    NBSP='&nbsp;'.html_safe
    BR='<br/>'.html_safe
    OK='[OK]'
    NOTOK='[NOTOK]'
    COPYRIGHT='&copy;'.html_safe
    
    def self.included(base)
      ApplicationHelper.class_eval { include LayoutHelper::ClassMethods }
    end
    
    module ClassMethods
      #
      # Usage <%= title 'Text to output and set as html-title -%>
      #
      def title(t,display=true)
        content_for :title do
          t
        end
        return t if display
      end
      
      #
      # object is a form-helper object
      # field is an active-record filed with errors
      #
      def display_errors_for(obj,field)
        content_tag :div, :class => 'error_for_field' do
          obj.errors[field.to_sym].map { |e| e.to_s }.join(", ")
        end
      end
      
      #
      # renders a form field with div-tags, label and the field given
      # in block. If the field contains erros, these errors are displayed
      # behind the input-field.
      #
      def input_field(f,obj,field,&block) 
        rc = "<div class='input_field'>".html_safe
        if f
          rc << f.label(field.to_sym)
        else
          rc << label_tag(field.to_sym)
        end
        rc << yield
        rc << LayoutHelper::NBSP + display_errors_for( obj, field.to_sym )
        rc << "</div>".html_safe
        rc
      end
      
      #
      # <%= page_menu [ 
      #              { :label => 'Home',  :url => root_path},
      #              { :label => 'About', :url => "/about"}
      #            ] -%>
      #
      # Define #page_menu and .current_page_link in your stylesheet
      #
      def page_menu(items, options={})
        defaults = { :id => 'page_menu', :item_class => 'current_page_link' }
        defaults.merge! options
        rc = (
              "<div id='#{defaults[:id]}'>"+
              "<ul>"
        ).html_safe
        items.each do |item|
          rc << "<li>".html_safe + 
            link_to_unless_current( item[:label], item[:url] ) {
              content_tag( :span, :class => "#{defaults[:item_class]}" ) {
                item[:label] 
              }
            } + 
            "</li>".html_safe
        end
        rc << "</ul>".html_safe
        rc << "<div class='clear_#{defaults[:clear]}'></div>".html_safe
        rc << "</div>".html_safe
        rc
      end
      
      #
      #  Display Session-info or Login-Link
      #
      def session_box(user_column='username', user_settings_path='/user')
        content_tag(:div , :id => 'application_title' ) {
          I18n.translate(APPLICATION_NAME)
        } + 
        content_tag( :div, :id => 'session_box') {
          if current_user && logged_in?
            link_to(t(:you_are_logged_in_as, 
              :username => current_user.send(user_column)),
              user_settings_path
            ) + ": " + NBSP +
            link_to( I18n.translate(:logout).gsub(/ /,"&nbsp;").html_safe, logout_path) +
            I18n.translate(:active_roles)  +
            User::ROLES.map { |role|  
               if current_user.role?(role) 
                 role[0].upcase
               else
                 role[0].downcase
               end
             }.join(", ")
          else
            link_to( I18n.translate(:login).gsub(/ /,"&nbsp;").html_safe, login_path)
          end
        }
      end
      
      #
      # Include static HTML-Pages
      #
      def html_include(filename)
        f = File::open(filename,'r')
        if f
          html = f.read
          f.close
        else
          html = I18n.translate(:file_not_found, :filename => filename)
        end
        html
      end
      
      def w3c_url(url)
        url.gsub(' ', '%20')
      end
      
    end # ClassMethods
    
end

