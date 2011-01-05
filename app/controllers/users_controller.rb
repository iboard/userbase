class UsersController < ApplicationController

  respond_to :html,:xml
  
  load_and_authorize_resource :except => [:update]                        # cancan
  before_filter :authorize_admin!, :except => [:avatar, :edit, :update]   # for admins only

  def index
    @users = User.all
  end
  
  def show
    redirect_to users_path
  end
  
  def edit
  end
    
  def update
    @user = User.find(params[:id])
    if @user
      authorize! :avatar, @user, :message => t(:no_access_to_avatar)
      if @user.update_attributes(params[:user])  
        flash[:notice] = "Successfully updated user."  
        if User.count == 1 && @user == User.first
          flash[:notice] += "<br/>First user is set to be an admin!".html_safe
          @user.roles=User::ROLES
          @user.save!
        end
        if params[:user][:avatar].blank?  
          if current_user.role? :admin
            redirect_to users_path
          else
            redirect_to user_settings_path
          end
        else
          render :action => 'crop'
        end  
      else  
        render :action => 'edit'  
      end
    else
      flash[:alert] = t(:user_not_found)
      redirect_to(users_path)
    end
  end
  
  def destroy
    notice_str = [@user.nickname,@user.email].join("/")
    @user.destroy
    redirect_to users_path, :notice => t(:account_deleted_successfully, :username => notice_str )
  end
  
  def avatar
    authorize! :avatar, @user
  end
  
  private
  # Authorize if current_user is an admin
  # If there is only and exact ONE user in the database and the ID of this user is 1
  # this will set admin-flags for the first user to do: being first is being admin ;-)
  def authorize_admin!
    user ||= current_user
    if User.count == 1
      user.roles=(User::ROLES)
      user.save!
    end
    unless user.role?(:admin) || user.role?(:staff)
      flash[:alert] = t(:please_login_as_admin_or_staff_to, :what => t(:user_maintainance))
      redirect_to root_path
    end
  end
 
end
