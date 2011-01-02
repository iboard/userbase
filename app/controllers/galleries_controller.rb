class GalleriesController < ApplicationController

  # Blogable Controller for class galleries  
  respond_to :html,:xml
  load_resource :user
  load_and_authorize_resource :gallery
  
  after_filter :unpack_archives, :only => [:update,:create]

  # GET /galleries  # GET /galleries.xml
  def index
    if @user
      galleries = @user.galleries.readable(current_user ? current_user.roles_mask : 1)\
        .order('updated_at desc')
    else
      galleries = Gallery.readable(current_user ? current_user.roles_mask : 1)\
        .order('updated_at desc')
    end
    
    unless session[:language_filter].blank?
      @galleries = galleries.with_locales(session[:language_filter]).paginate(:page => params[:page], :per_page => CONSTANTS['paginate_postings_per_page'])
    else
      @galleries = galleries.paginate(:page => params[:page], :per_page => CONSTANTS['paginate_postings_per_page'])
    end    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @galleries }
    end
  end

  # GET /galleries/1
  # GET /galleries/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @gallery }
    end
  end

  # GET /galleries/new
  # GET /galleries/new.xml
  def new
    @gallery = @user.galleries.build
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @gallery }
    end
  end

  # GET /galleries/1/edit
  def edit
  end

  # POST /galleries  # POST /galleries.xml
  def create
    @gallery = @user.galleries.build(params[:gallery])

    respond_to do |format|
      if @gallery.save
        format.html { redirect_to(user_gallery_path(@user,@gallery), :notice => 'Gallery was successfully created.') }
        format.xml  { render :xml => @gallery, :status => :created, :location => @gallery }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @gallery.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /galleries/1
  # PUT /galleries/1.xml
  def update
    respond_to do |format|
      if @gallery.update_attributes(params[:gallery])
        format.html { redirect_to(user_gallery_path(@user,@gallery), :notice => 'Gallery was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @gallery.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /galleries/1
  # DELETE /galleries/1.xml
  def destroy
    unless @user
      @user = @gallery.user if can? :manage, @gallery
    end
    
    if can? :manage, @gallery
      @gallery.destroy
    
      respond_to do |format|
        format.html { redirect_to(user_galleries_url(@user)) }
        format.xml  { head :ok }
      end
    else
      redirect_to root_path, :error => t(:access_denied)
    end
  end
  
  private
  
  def unpack_archives
    flash[:notice] ||= ""
    @gallery.assets.where("asset_file_name like ?", "%.zip").each do |asset|
      flash[:notice] += " Your file #{asset.asset_file_name} will be processed in background. The gallery will be available when all images are processed."
      
      Delayed::Job.enqueue ProcessGallery.new(@gallery.id)
      
    end
  end
  
end
