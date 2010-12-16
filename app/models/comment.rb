class Comment < ActiveRecord::Base
  belongs_to      :commentable, :polymorphic => true
  belongs_to      :user
  
  validates :user_id, :presence => true, :user_exists => true
  validates :email,   :presence => true, :email => true
  validates :comment, :presence => true, :length => {:minimum => 10}
  
  def body
    comment
  end
  alias_method :object_body, :body
  
  def title
    I18n.translate(:comment_on, :item => commentable.object_title )
  end
  alias_method :object_title, :title
    
end
