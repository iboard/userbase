class StaticPagesController < ApplicationController
  
  respond_to :html
  before_filter :authorize_admin
  
  STATIC_PAGE_PATH = File::join(Rails.root,"public","static_pages")
  
  def index
    @files = Dir.new(STATIC_PAGE_PATH).select{ |f| f if f =~ /html$/ }
  end
  
  def edit
    @file_name = File::join(STATIC_PAGE_PATH,Base64::decode64(params[:file_name]))
    @content = File.new(@file_name).read
  end
  
  def update
    file_name = File::join(STATIC_PAGE_PATH,Base64::decode64(params[:file_name]))
    file = File.new(file_name,"w")
    file << params['static_file'][':content']
    file.close
    redirect_to :action => :index, :notice => t(:file_saved_successfully)
  end
  
  private
  def authorize_admin
    redirect_to new_user_session_path unless current_user && current_user.role?(:admin)
  end
end
