class EpisodesController < ApplicationController
  respond_to :html,:xml

  load_resource :user
  load_and_authorize_resource :episode
  
  # GET /episodes
  # GET /episodes.xml
  def index
    episodes = Episode.readable(current_user ? current_user.roles_mask : 1).order("updated_at desc")
    if session[:language_filter].blank?
      @episodes = episodes.paginate( :page => params[:page], :per_page => CONSTANTS['paginate_episodes_per_page'])
    else
      @episodes = episodes.with_locales(session[:language_filter]).paginate( :page => params[:page], :per_page => CONSTANTS['paginate_episodes_per_page'])
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @episodes }
    end
  end

  # GET /episodes/1
  # GET /episodes/1.xml
  def show
    @episode = Episode.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @episode }
    end
  end

  # GET /episodes/new
  # GET /episodes/new.xml
  def new
    @episode = current_user.episodes.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @episode }
    end
  end

  # GET /episodes/1/edit
  def edit
    @episode = Episode.find(params[:id])
  end

  # POST /episodes
  # POST /episodes.xml
  def create
    @episode = Episode.new(params[:episode])
    @episode.user = current_user
    respond_to do |format|
      if @episode.save
        format.html { redirect_to(@episode, :notice => 'Episode was successfully created.') }
        format.xml  { render :xml => @episode, :status => :created, :location => @episode }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @episode.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /episodes/1
  # PUT /episodes/1.xml
  def update
    @episode = Episode.find(params[:id])

    respond_to do |format|
      if @episode.update_attributes(params[:episode])
        format.html { redirect_to(@episode, :notice => 'Episode was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @episode.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /episodes/1
  # DELETE /episodes/1.xml
  def destroy
    @episode = Episode.find(params[:id])
    @episode.destroy

    respond_to do |format|
      format.html { redirect_to(episodes_url) }
      format.xml  { head :ok }
    end
  end
  
  def tag
    @episodes = Episode.tagged_with(params[:tag], :on => :tags)\
      .readable(current_user ? current_user.roles_mask : 1)\
      .order('updated_at desc').uniq\
      .paginate(:page => params[:page], :per_page => CONSTANTS['paginate_postings_per_page'])
    render :index
  end
 
end
