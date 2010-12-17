class PostingsController < ApplicationController

  respond_to :html,:xml, :rss

  load_resource :user, :except => :preview
  load_and_authorize_resource :posting, :except => :preview
  
  after_filter :apply_user_tags, :only => [:create, :update]
  
  # GET /postings
  # GET /postings.xml
  def index
    if @user
      postings = @user.postings.readable(current_user ? current_user.roles_mask : 1)\
        .order('updated_at desc')
    else
      postings = Posting.readable(current_user ? current_user.roles_mask : 1)\
        .order('updated_at desc')
    end
    
    unless session[:language_filter].blank?
      @postings = postings.with_locales(session[:language_filter]).paginate(:page => params[:page], :per_page => CONSTANTS['paginate_postings_per_page'])
    else
      @postings = postings.paginate(:page => params[:page], :per_page => CONSTANTS['paginate_postings_per_page'])
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @postings }
    end
  end

  # GET /postings/1
  # GET /postings/1.xml
  def show
    @posting = Posting.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @posting }
    end
  end

  # GET /postings/new
  # GET /postings/new.xml
  def new
    @posting = Posting.new(:user_id => current_user.id, 
                           :access_read_mask => current_user.roles_mask,
                           :access_manage_mask => current_user.roles_mask
                          )
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @posting }
    end
  end

  # GET /postings/1/edit
  def edit
    @posting = Posting.find(params[:id])
  end

  # POST /postings
  # POST /postings.xml
  def create
    params[:posting][:access_manage_mask_flags] ||= []
    @posting = @user.postings.create(params[:posting])
    respond_to do |format|
      if @posting.save
        format.html { redirect_to(user_posting_path(@user,@posting), :notice => 'Posting was successfully created.') }
        format.xml  { render :xml => @posting, :status => :created, :location => @posting }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @posting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /postings/1
  # PUT /postings/1.xml
  def update
    params[:posting][:access_manage_mask_flags] ||= []
    @posting = @user.postings.find(params[:id])

    respond_to do |format|
      if @posting.update_attributes(params[:posting])
        format.html { redirect_to(user_posting_path(@user,@posting), :notice => 'Posting was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @posting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /postings/1
  # DELETE /postings/1.xml
  def destroy
    @posting = Posting.find(params[:id])
    @posting.destroy

    respond_to do |format|
      format.html { redirect_to(postings_url) }
      format.xml  { head :ok }
    end
  end
  
  def tag
    @postings = Posting.tagged_with(params[:tag], :on => :tags)\
      .readable(current_user ? current_user.roles_mask : 1)\
      .order('updated_at desc').uniq\
      .paginate(:page => params[:page], :per_page => CONSTANTS['paginate_postings_per_page'])
    @tag = params[:tag]
    render :index
  end
  
  def preview
    render :layout => false
  end
  
  private
  def load_user
    if params[:user_id]
      @user = User.find(params[:user_id])
    else
      @user = nil
    end
  end
  
  def apply_user_tags
    if @user && @posting
      @user.tag(@posting, :with => @posting.tag_list, :on => :tags)
    end
  end

end
