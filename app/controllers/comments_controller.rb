class CommentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_comment,                                         except: :create
  before_filter :allow_only_admins_moderators_and_authors_to_comments, except: :create
  after_filter  :log_user_action_for_comments,                         only:   [:create, :update, :destroy] 
  
  def create
    @comment = Comment.create(params[:comment].merge({user: current_user}))
    if @comment.errors.empty?
      redirect_to @comment.post
      flash[:success] = "Comment successfully created."
    else
      @post = @comment.post
      unsorted_comments = @post.comments.includes(:user) 
      sort_comments_in_tree unsorted_comments
      flash.now[:error] = "You made mistakes in your form! Please correct them. Comment length should be in the range of 1 to 50 words. "
      render "posts/show"
    end
  end
  
  def show
  
  end
  
  def edit
  end
  
  def update
    @previous_body = @comment[:body]
    @comment.update_attributes(params[:comment].merge({user: current_user}))
    if @comment.errors.empty?
      flash[:success] = "Comment successfully created."
      redirect_to @comment.post
    else
      flash.now[:error] = "You made mistakes in your form! Please correct them. Comment length should be in the range of 1 to 50 words."
      render "edit"
    end
    
  end
  
  def destroy
    
    #@childs = @comment.comment.body
    @comment.destroy
    redirect_to @comment.post
  end
  
  private
    def allow_only_admins_moderators_and_authors_to_comments
      if @comment.user != current_user && current_user.role.nil? 
      	render_403
      end
    end
  
    def find_comment
      @comment = Comment.where(id: params[:id]).first
      render_404 unless @comment 
    end
    
    
    
    def log_user_action_for_comments
      if current_user && ( current_user.role == "admin" || current_user.role == "moderator" )
        UserAction.create(
          user: current_user, 
          description: log_description(params[:action])
      	         
      )
      end
    end
    
    def log_description(x)
      if x == "create"
        return "Controller: #{params[:controller]} || Action: #{params[:action]} || Id: #{@comment.id} || Post_id: #{@comment.post_id} || Comments_id: #{@comment.comment_id } ||  Text: #{@comment.body}"
      end
      if x == "update"
        return "Controller: #{params[:controller]} || Action: #{params[:action]} || Id: #{@comment.id} || Post_id: #{@comment.post_id} || Comments_id: #{@comment.comment_id } || Previous_Text: #{@previous_body} || Text: #{@comment.body}"
      end
      if x == "destroy"
        return "Controller: #{params[:controller]} || Action: #{params[:action]} || #{@comment.id} || Post_id: #{@comment.post_id} || Comments_id: #{@comment.comment_id } || Text: #{@comment.body}"
      end
      
    end
    
    
  
  
  
end
