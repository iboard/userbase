class SubscriptionsController < ApplicationController
  load_and_authorize_resource :subscription
  load_and_authorize_resource :user
  
  # GET /subscriptions
  # GET /subscriptions.xml
  def index
    @subscriptions = @user ? @user.subscriptions.all : Subscription.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @subscriptions }
    end
  end

  # GET /subscriptions/1
  # GET /subscriptions/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @subscription }
    end
  end

  # GET /subscriptions/new
  # GET /subscriptions/new.xml
  def new
    @subscription = @user.subscriptions.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @subscription }
    end
  end

  # GET /subscriptions/1/edit
  def edit
    @subscription = @user.subscriptions.find(params[:id])
  end

  # POST /subscriptions
  # POST /subscriptions.xml
  def create
    @subscription = @user.subscriptions.build(params[:subscription])

    respond_to do |format|
      if @subscription.save
        format.html { redirect_to(user_subscriptions_path(@user), :notice => 'Subscription was successfully created.') }
        format.xml  { render :xml => @subscription, :status => :created, :location => @subscription }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @subscription.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /subscriptions/1
  # PUT /subscriptions/1.xml
  def update
    @subscription = @user.subscriptions.find(params[:id])

    respond_to do |format|
      if @subscription.update_attributes(params[:subscription])
        format.html { redirect_to(user_subscriptions_path(@user), :notice => 'Subscription was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @subscription.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /subscriptions/1
  # DELETE /subscriptions/1.xml
  def destroy
    @subscription = @user.subscriptions.find(params[:id])
    @subscription.destroy

    respond_to do |format|
      format.html { redirect_to(user_subscriptions_url(@user)) }
      format.xml  { head :ok }
    end
  end
  
  # GET /user/:id/:subscription_id/notify
  def notify
    @subscription = @user.subscriptions.find(params[:id])
    @subscription.deliver_notifications(@user)
    redirect_to user_subscription_path(@user,@subscription), :notice => t(:notifications_queued)
  end
end
