class BlogController < ApplicationController
  
  def index
    @blog_entries =  Blogables::blog_entries(current_user,blog_order,blog_dir).paginate(:page => params[:page], :per_page => CONSTANTS['paginate_blog_entries_per_page'])
  end
  
  def tag
    @blog_entries =  Blogables::filtered_by(current_user,blog_order,blog_dir) { |resource|
       !resource.tag_list.include?(params[:tag])
    }.paginate(:page => params[:page], :per_page => CONSTANTS['paginate_blog_entries_per_page'])
    render :index
  end
  
  
  # GET /archive/:month
  def archive
    from_year  = params[:month].split("_")[0]
    from_month = params[:month].split("_")[1]
    from_date = Time.parse( "#{from_year}-#{from_month}-01 00:00:00")
    to_date   = from_date+1.month-1.second
    @archive  = BlogEntry.filtered_by(current_user,blog_order,blog_dir) {|r|
      !( r.created_at >= from_date && r.created_at <= to_date )
    }
    @blog_entries = @archive.paginate(:page => params[:page], :per_page => CONSTANTS['paginate_blog_entries_per_page'])
    render :index
  end
  
  
  
  
  private
  def blog_order
     params[:blog_order] ||= 'updated_at'
   end

   def blog_dir
     params[:blog_dir]   ||= 'desc'
   end
end
