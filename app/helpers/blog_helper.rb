module BlogHelper
  
  
  def order_links
    params[:blog_order] ||= 'updated_at'
    params[:blog_dir]   ||= 'desc'
    
    columns = ['created_at', 'updated_at', 'author', 'title' ]
    columns += ['ratings_count', 'ratings_average'] unless ratings_hidden?
    columns.map { |column|
      if column == params[:blog_order]
        (  "<b>"+
             link_to( t(column.to_sym), reverse_path ).html_safe+
           "</b>"+
             link_to( image_tag( "/images/direction_#{params[:blog_dir]}.png", :class => 'direction_icon' ),
               reverse_path).html_safe
        ).html_safe
      else
        link_to(t(column.to_sym), forward_path(column,params[:blog_dir]))
      end
    }.join(" | ").html_safe
  end
  
  
  def tag_list(list)
    list.map { |tag| 
      link_to( tag, tag_path(tag) )
    }.join(", ").html_safe
  end
  
  def site_keywords
    
    return @keywords if defined?(@keywords)
    
    @keywords = []
    if @blog_entry
      @keywords << @blog_entry.tag_list
      @keywords << @blog_entry.author
    end
    if @blog_entries
      @keywords << @blog_entries.map(&:tag_list).flatten.uniq.sort
      @keywords << @blog_entries.map(&:author).flatten.uniq.sort
    end
    
    Blogables::blog_models.each do |resource|
      single_resource = eval("@#{resource.name.singularize.underscore}")
      list_resource = eval("@#{resource.name.pluralize.underscore}")
      if single_resource
        @keywords << single_resource.try('tag_list')
        @keywords << single_resource.try('author')
      end
      if list_resource
        @keywords << list_resource.map(&:tag_list).flatten.uniq.sort
        @keywords << list_resource.map(&:author).flatten.uniq.sort
      end
    end
    @keywords = @keywords.flatten.sort.uniq
    Rails.logger.info("**KEYWORDS #{@keywords.inspect}")
    @keywords
  end
    
  def ajax_path
    if params[:tag]
      tag_path(params[:tag], :page => (params[:page] ? (params[:page].to_i+1) : 2), 
                            :blog_order => params[:blog_order], 
                            :blog_dir => params[:blog_dir] )
    elsif params[:month]
      archive_path(params[:month], :page => (params[:page] ? (params[:page].to_i+1) : 2), 
                              :blog_order => params[:blog_order], 
                              :blog_dir => params[:blog_dir] )
    else
      blog_path(:page => (params[:page] ? (params[:page].to_i+1) : 2), 
                            :blog_order => params[:blog_order], 
                            :blog_dir => params[:blog_dir] )
    end                         
  end

  private
  def reverse_path
    if request.path.split('/')[1] == 'tag'
      blog_tag_path(params[:tag], params[:blog_order], params[:blog_dir] == 'asc' ? 'desc' : 'asc')
    elsif request.path.split('/')[1] == 'archive'
      archive_path(params[:month], :blog_order => params[:blog_order], :blog_dir => params[:blog_dir] == 'asc' ? 'desc' : 'asc')
    else
      blog_path(params[:blog_order], params[:blog_dir] == 'asc' ? 'desc' : 'asc')
    end
  end
  
  def forward_path(c,d)
    if request.path.split('/')[1] == 'tag'
      blog_tag_path(params[:tag], c, d)
    elsif request.path.split('/')[1] == 'archive'
      archive_path(params[:month], :blog_order => c, :blog_dir => d)
    else
      blog_path(c,d)
    end
  end
  
end
