class PostsController < ApplicationController
  before_filter :authenticate_user!,                                            except: [:index]
  before_filter :find_post,                                                     only:   [:destroy, :update, :edit, :show]
  before_filter :allow_only_admins_moderators_and_authors_to_posts,             only:   [:update, :edit, :destroy]
  after_filter  :log_user_action_for_posts,                                     only:   [:create, :update, :destroy]
  
  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.order("created_at DESC").includes(:user)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    old = @post.comments.includes(:user)
    sort_comments_in_tree old
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
   end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(params[:post])
    @post.user = current_user

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    
    @previous_content = @post[:content]
    respond_to do |format|
      if @post.update_attributes(params[:post])
      	
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
        
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @previous_content = @post.content 
    @post.destroy
    
    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end
  
  
  def edit_comment(params)
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
  end
  
  def update_comment(params)
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    @comment.update_attributes(params[:comment])
    redirect_to post_path(@post)
    
  end
  
  
  private
  
    def allow_only_admins_moderators_and_authors_to_posts
      if @post.user != current_user && current_user.role.nil? 
      	render_403
      end
    end
    
    def find_post
      @post = Post.where(id: params[:id]).first
      render_404 unless @post 
    end
    
    def log_user_action_for_posts
    @user_presence = true
    if current_user && ( current_user.role == "admin" || current_user.role == "moderator" )
      UserAction.create(
        user: current_user, 
        description: log_description(params[:action])
      )
      end
    end
    

    
   def log_description(x)
     if x == "create"
       return "Controller: #{params[:controller]} || Action: #{params[:action]} || Id: #{@post.id} || Text: #{@post.content}"
     end
     if x == "update"
       return "Controller: #{params[:controller]} || Action: #{params[:action]} || Id: #{@post.id} || Previous_Text: #{@previous_content} || Text: #{@post.content}"
     end
     if x == "destroy"
       return "Controller: #{params[:controller]} || Action: #{params[:action]} || Id: #{@post.id} || Text: #{@post.content}"
     end
     
   end
    
    
    
    
  
  
end
