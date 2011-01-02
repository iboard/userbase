class <%= @resource_plural.camelize -%>Controller < ApplicationController

  # Blogable Controller for class <%= @resource_plural -%>
  
  respond_to :html,:xml
  load_resource :user
  load_and_authorize_resource :<%= @resource_single.underscore -%>


  # GET /<%= @resource_plural -%>
  # GET /<%= @resource_plural -%>.xml
  def index
    if @user
      <%= @resource_plural.underscore -%> = @user.<%= @resource_plural.underscore -%>.readable(current_user ? current_user.roles_mask : 1)\
        .order('updated_at desc')
    else
      <%= @resource_plural.underscore -%> = <%= @resource_single.camelize -%>.readable(current_user ? current_user.roles_mask : 1)\
        .order('updated_at desc')
    end
    
    unless session[:language_filter].blank?
      @<%= @resource_plural.underscore -%> = <%= @resource_plural.underscore -%>.with_locales(session[:language_filter]).paginate(:page => params[:page], :per_page => CONSTANTS['paginate_postings_per_page'])
    else
      @<%= @resource_plural.underscore -%> = <%= @resource_plural.underscore -%>.paginate(:page => params[:page], :per_page => CONSTANTS['paginate_postings_per_page'])
    end    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @<%= @resource_plural.underscore -%> }
    end
  end

  # GET /<%= @resource_plural -%>/1
  # GET /<%= @resource_plural -%>/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @<%= @resource_single.underscore -%> }
    end
  end

  # GET /<%= @resource_plural -%>/new
  # GET /<%= @resource_plural.underscore -%>/new.xml
  def new
    @<%= @resource_single -%> = @user.<%= @resource_plural.underscore -%>.build
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @<%= @resource_single.underscore -%> }
    end
  end

  # GET /<%= @resource_plural -%>/1/edit
  def edit
  end

  # POST /<%= @resource_plural -%>
  # POST /<%= @resource_plural -%>.xml
  def create
    @<%= @resource_single.underscore -%> = @user.<%= @resource_plural.underscore -%>.build(params[:<%= @resource_single.underscore -%>])

    respond_to do |format|
      if @<%= @resource_single -%>.save
        format.html { redirect_to(user_<%= @resource_single.underscore -%>_path(@user,@<%= @resource_single.underscore -%>), :notice => '<%= @resource_single.camelize -%> was successfully created.') }
        format.xml  { render :xml => @<%= @resource_single.underscore -%>, :status => :created, :location => @<%= @resource_single.underscore -%> }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @<%= @resource_single.underscore -%>.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /<%= @resource_plural -%>/1
  # PUT /<%= @resource_plural -%>/1.xml
  def update
    respond_to do |format|
      if @<%= @resource_single.underscore -%>.update_attributes(params[:<%= @resource_single.underscore -%>])
        format.html { redirect_to(user_<%= @resource_single.underscore -%>_path(@user,@<%= @resource_single.underscore -%>), :notice => '<%= @resource_single.camelize -%> was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @<%= @resource_single.underscore -%>.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /<%= @resource_plural -%>/1
  # DELETE /<%= @resource_plural -%>/1.xml
  def destroy
    unless @user
      @user = @<%= @resource_single.underscore -%>.user if can? :manage, @<%= @resource_single.underscore %>
    end
    
    if can? :manage, @<%= @resource_single.underscore %>
      @<%= @resource_single.underscore -%>.destroy
    
      respond_to do |format|
        format.html { redirect_to(user_<%= @resource_plural.underscore -%>_url(@user)) }
        format.xml  { head :ok }
      end
    else
      redirect_to root_path, :error => t(:access_denied)
    end
  end
end
