class ApplicationController < ActionController::Base
  
  
  protect_from_forgery
 
  private
  
  def render_404
  	  render file: "public/404.html", status: 404
  end
  
  def render_403
  	  render file: "public/403.html", status: 403
  end
  
  def allow_only_admins
    if  current_user.role != "admin" 
      render_403
    end
  end
  
  
  
  def log_user_action_for_devise
    if current_user && ( current_user.role == "admin" || current_user.role == "moderator" )
      UserAction.create(
        user: current_user, 
        description: 
      	        "Controller: #{params[:controller]}, Action: #{params[:action]}"
    )
    end
  end
  
  
  def sort_comments_in_tree(old)
    
      l=0;
      @comments = Array.new
      a         = Array.new
      old.each do |old|
        if old.comment_id == nil
          @comments << old
        end
      end
    
      @comments.each do |comment|
        comment.level = 0
      end
    
      old.delete_if{ |old| old.comment_id == nil }
      old.sort_by!{ |old| old.comment_id }
    
    
      l=0
      p=0
      @level = 0
      while old[l] != nil
        a = []
        while true
        
          if old[l+1] == nil || old[l][:comment_id] != old[l+1][:comment_id]
            a << old[l]
             l=l+1
            break    
          else
            a << old[l]
            l=l+1
          end   
        end
    
        a.sort_by!{|a| a[:created_at]}
        k=0
       
        while a[k] != nil 
          old[p] = a[k] 
          k=k+1
          p=p+1
        end
        @level = @level + 1
      end
    
    
    
    
       
      l=0
      k=1
    
      while old[l] != nil
        m=0
        while old[l].comment_id != @comments[m].id 
          m=m+1
          k=1
        end
      
      
        while old[l] && old[l].comment_id == @comments[m].id
        
          @comments.insert(m+k, old[l])
         
          if k==1 
            @comments[m+k].level = @comments[m].level + 1
          else
            @comments[m+k].level = @comments[m+k-1].level
          end
        
        
          l=l+1
          k=k+1
        end
     
      end
    end

  

end
