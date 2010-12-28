module BlogHelper
  
  
  def order_links
    params[:blog_order] ||= 'updated_at'
    params[:blog_dir]   ||= 'desc'
    
    ['created_at', 'updated_at', 'author', 'ratings_count','ratings_average', 'title' ].map { |column|
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
