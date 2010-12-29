class BlogController < ApplicationController
  
  def index
    @blog_entries =  Blogables::blog_entries(current_user,blog_order,blog_dir,session[:language_filter]).paginate(:page => params[:page], :per_page => CONSTANTS['paginate_blog_entries_per_page'])
    respond_to do |format|
      format.js
      format.html
    end
  end
  
  def tag
    @blog_entries =  Blogables::filtered_by(current_user,blog_order,blog_dir,session[:language_filter]) { |resource|
       !resource.tag_list.include?(params[:tag])
    }.paginate(:page => params[:page], :per_page => CONSTANTS['paginate_blog_entries_per_page'])
    logger.info("*** RENDER INDEX NOW ****")
    respond_to do |format|
       format.js { render :index }
       format.html { render :index }
    end
  end
  
  
  # GET /archive/:month
  def archive
    from_year  = params[:month].split("_")[0]
    from_month = params[:month].split("_")[1]
    from_date = Time.parse( "#{from_year}-#{from_month}-01 00:00:00")
    to_date   = from_date+1.month-1.second
    @archive  = BlogEntry.filtered_by(current_user,blog_order,blog_dir,session[:language_filter]) {|r|
      !( r.created_at >= from_date && r.created_at <= to_date )
    }
    @blog_entries = @archive.paginate(:page => params[:page], :per_page => CONSTANTS['paginate_blog_entries_per_page'])
    logger.info("*** RENDER INDEX NOW ****")
    respond_to do |format|
       format.js { render :index }
       format.html { render :index }
    end
  end
  
  # GET 'create_translation/:resource/:id/:locale'
  def translation
    resource    = eval(params[:resource].humanize)
    original    = resource.find(params[:id])
    translation = resource.create(original.attributes)
    translation.user_id = current_user.id
    translation.title = 'TRANSLATE TO '+params[:locale]+" "+translation.title
    translation.locale = params[:locale]
    translation.save!
    original.translations.create(:translated_id => translation.id, :locale => translation.locale)
    translation.translations.create(:translated_id => original.id, :locale => original.locale)
    redirect_to eval("edit_user_#{params[:resource].downcase}_path(#{current_user.id},#{translation.id})"), :notice => t(:translation_created)
  end
    
  private
  def blog_order
     params[:blog_order] ||= 'updated_at'
   end

   def blog_dir
     params[:blog_dir]   ||= 'desc'
   end
end
