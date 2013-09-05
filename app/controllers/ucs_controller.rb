class UcsController < ApplicationController
	
  before_filter :authenticate_user!  
  before_filter :find_user,                   only: [:show,:edit,:update, :destroy]
  before_filter :allow_only_admins,           only: [:index,:edit,:update, :destroy]
  after_filter  :log_user_action_for_update,  only:  :update
  after_filter  :log_user_action_for_destroy, only:  :destroy
  def index
    @users = User.all
    @posts = Post.order("created_at DESC").includes(:user)
  end
  
  def show
    unless  @user 
    render_404
    end  	    
  end
  
 # def new
  #  @user = User.new
  #end
  
  def edit
  end
  
  #def create 
    #render text: params.inspect
   # @user = User.create(params[:user])
    #if @user.errors.empty?
     # redirect_to uc_path(@user)
    #else
     # "new"
    #end
  #end
  
  def update
    @previous_login = @user.login
    @previous_role  = @user.role
    @user.update_attributes(params[:user])
    if @user.errors.empty?
      redirect_to ucs_path(@user)
    else
      "edit"
    end
  end
  
  def destroy
    @user.destroy
    redirect_to action: "index"
  end
  
  private 
  
  def find_user
    @user = User.where(id: params[:id]).first
    render_404 unless @user
    
  end
  
  def log_user_action_for_update
    @user_presence = true
    if current_user && ( current_user.role == "admin" )
      UserAction.create(
        user: current_user, 
        description: 
      	        "Controller: #{params[:controller]} || Action: #{params[:action]} || email: #{@user.email} || Previous_Login: #{@previous_login}  || Login: #{@user.login} || Previous_Role: #{@previous_role} || Role: #{@user.role}"
    )
    end
  end
  
  def log_user_action_for_destroy
    @user_presence = false
    if current_user && ( current_user.role == "admin")
      UserAction.create(
        user: current_user, 
        description: 
      	        "Controller: #{params[:controller]} || Action: #{params[:action]} || email: #{@user.email} || Login: #{@user.login} || Role: #{@user.role}"
    )
    end
  end
  
  
  
end

