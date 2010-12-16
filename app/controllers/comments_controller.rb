#
#  ApplicationController
#  Andi Altendorfer <andreas@altendorfer.at>
#  2010-09-12
#

class CommentsController < ApplicationController

  before_filter :load_path, :except => [:destroy,:index, :show]
  before_filter :load_commentable, :only => [:show]
  
  load_and_authorize_resource

  def index
    begin
      load_path
      @comments = @commentable.comments.all
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @comments }
      end
    rescue => e
      respond_to do |format|
        format.html { redirect_to root_path, :alert => e.message.to_s.html_safe }
        format.xml { render :xml => e.message, :status => :unprocessable_entity }
      end
    end
  end

  def new
    @comment = @commentable.comments.build(:user => current_user, :email => current_user.email)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comment }
    end
  end
  
  def edit
    @user = User.find(params[:user_id])
    if current_user.role?(:admin)
      @comment = @user.comments.find(params[:id])
    else
      @comment = current_user.comments.find(params[:id])
    end
    @commentable = @comment.commentable
    respond_to do |format|
      format.html # edit.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  def update
    @user = User.find(params[:user_id])
    if current_user.role?(:admin)
      @comment = @user.comments.find(params[:id])
    else
      @comment = current_user.comments.find(params[:id])
    end

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to(@commentable, :notice => 'Comment was successfully created.') }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  def create
    @comment = @commentable.comments.build(params[:comment].merge(:user => current_user, :email => current_user.email))
    respond_to do |format|
      if @comment.save
        format.html { redirect_to(@commentable, :notice => 'Comment was successfully created.') }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end


  def show
    if @commentable
      redirect_to( :controller => @commentable.class.to_s.pluralize.underscore, :action => 'show',  :user_id => @commentable.user_id, :id => @commentable.id )
    else
      redirect_to( root_path, :alert => t(:commentable_not_found))
    end
  end


  def destroy
    @user = User.find(params[:user_id])
    if current_user.role?(:admin)
      @comment = @user.comments.find(params[:id])
    else
      @comment = current_user.comments.find(params[:id])
    end
    @commentable = @comment.commentable
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to(@commentable) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  
  # Any 'Commentable' may use 'Comments'.
  # load_path tries to find the commentable_id which may be posting_id, episode_id, anything_id
  # Each commentable belongs to an User - user_id is mapped to @user where any other commentable_id
  # will be mapped to @commentable.
  # If the URI doesn't contains a commentable_id the method assumes that :id is the ID of a
  # Comment itself. 
  def load_path
    resources = params.collect { |p| p[0] if p[0].match /(\S+)_id$/ }.reject { |r| r.nil? }
    resources.each do |r|
      self.instance_variable_set "@"+r.gsub(/_id$/,''), res = eval("#{r.camelize.gsub(/Id/,'')}.find(#{params[r.to_sym]})")
      if r != 'user_id'
        @commentable = res
      else
        @user = User.find(params[:user_id])
      end
    end
    
    # last try to fetch the commentable
    unless @commentable
      @comment ||= Comment.find(params[:id])
      @commentable = @comment.commentable
    end
    
    errors ||= []
    errors << t(:no_comment_without_a_commentable) unless @commentable
    errors << t(:no_comment_without_a_current_user) unless @user
    raise RuntimeError.new(:message => errors.join("\n<br/>".html_safe)) unless errors.empty?
  end
  
  # If :id is the id of a comment itself load the corresponding commentable model
  def load_commentable
    @comment = Comment.find(params[:id])
    @commentable = @comment.commentable
  end
  
end
