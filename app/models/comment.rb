class Comment < ActiveRecord::Base
  belongs_to      :commentable, :polymorphic => true
  belongs_to      :user
  
  validates :user_id, :presence => true, :user_exists => true
  validates :email,   :presence => true, :email => true
  validates :comment, :presence => true, :length => {:minimum => 10}
  
  after_create  :inform_owner
  
  def body
    comment
  end
  
  alias_method :object_body, :body
  
  def title
    I18n.translate(:comment_on, :item => commentable.object_title )
  end
  
  alias_method :object_title, :title

  def inform_owner
    Delayed::Job.enqueue( NewCommentNotifier.new(self.id), 
      { :run_at =>   Time.now()+(CONSTANTS['delay_new_posting_notifications'].to_i).seconds }
    )
  end    
end
