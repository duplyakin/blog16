require 'spec_helper'

describe CommentsController do
  
  describe 'create action' do
    
    it "redirects to comment's post if validations pass" do 
      post1 = Post.create(title: "post1")
      sign_in User.create(email: "em1@mail.ru",password: "12345678", password_confirmation: "12345678" )
      post :create, comment: {post_id: 1, body: "test" }
      response.should redirect_to(post1)
      assigns(:comment).new_record?.should == false
      
    end
  
  end	
	
end
