class UserActionsController < ApplicationController
  before_filter :authenticate_user! 
  before_filter :allow_only_admins 
  def index
    @user_actions = UserAction.order("created_at DESC").includes(:user)
  end
  
   def destroy
    @user_action = UserAction.where(id: params[:id]).first
    
    @user_action.destroy
    redirect_to action: "index"
  end
  
end
