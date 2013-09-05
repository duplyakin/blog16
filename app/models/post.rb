class Post < ActiveRecord::Base
  
  validates :title, :presence => true,
  :length => { :minimum => 3 }
  attr_accessible :author, :content, :title
  belongs_to :user
  has_many   :comments, :dependent => :destroy
  
end
