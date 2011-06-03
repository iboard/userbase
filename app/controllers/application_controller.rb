#
#  ApplicationController
#  Andi Altendorfer <andreas@altendorfer.at>
#  2010-09-12
#

class ApplicationController < ActionController::Base
  
  protect_from_forgery
  layout 'application'
  

  before_filter :set_language
  before_filter :load_tags
  before_filter :load_archive_links
#  before_filter :browser_warning
  
  # Display a flash if CanCan doesn't allow access    
  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    redirect_to root_url
  end

  
  #
  # Only show episodes and postings of the checked languages
  # If all languages are switched off this function will turn all
  # languages on again.
  def set_language_filter
    session[:language_filter] ||= []
    if params[:locale] == 'all'
      session[:language_filter] = []
    else
      if session[:language_filter].include?(params[:locale])
        session[:language_filter] -= [params[:locale]] 
      else
        session[:language_filter] += [params[:locale]]
      end
    end
  end
  
  # Switch the actual locale and save it in the session
  def switch_language
    I18n.locale = params[:lang]
    session[:lang] = params[:lang]
    respond_to do |f|
        f.js 
        f.html
    end
  end

  private
   
  # set the I18.locale to the value stored in user-settings
  def set_language
    return if request.fullpath.match(/^\/(\S+)preview/)
    unless current_user.nil?
      I18n.locale = current_user.language
    end
    I18n.locale = session[:lang] if session[:lang]
  end  
  
  # load any Taggables used in tag-clouds
  # TODO: Cache this in any way!
  def load_tags
    return if request.fullpath.match(/^\/(\S+)preview/)
    
    load = Rails.cache.read('tags')
    if load.nil?
      load = blog_models.map { |resource|
                resource.tag_counts_on(:tags).all
              }.flatten.uniq.sort { |a,b| 
                a.name.upcase <=> b.name.upcase
              }
       Rails.cache.write('tags', load)
    end
    @tags = load
  end
  
  # load all commentables, grouped by year/month
  def load_archive_links
    return if request.fullpath.match(/^\/(\S+)preview/)
    
    load = Rails.cache.read('archive_links')
    if load.nil?
      rc = {}
      Commentables::group_by_month.each do |c|
         c.each do |cc|
           if rc[cc[0]]
             rc[cc[0]] += cc[1].count
           else
             rc[cc[0]] = cc[1].count
           end
         end
      end
      load = rc
      Rails.cache.write('archive_links',load)
    end
    @archive_links = load
  end
  
 # # display a warning if someone is using MSIE
 # def browser_warning
 #   return if request.fullpath.match(/^\/(\S+)preview/)
 #   
 #   if request.env['HTTP_USER_AGENT'] =~ /MSIE/
 #     unless session[:browser_warning_displayed]
 #       flash.now[:error] = t(:wrong_browser)
 #       session[:browser_warning_displayed] = Time.now()
 #     end
 #   end
 # end

end
