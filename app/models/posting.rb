class Posting < ActiveRecord::Base

  is_blogable
  validates :body,    :presence => true
      
  
  #Notifiers
  after_create :async_notify_on_creation

  private
  # Send an email to the owner/author of this posting
  def async_notify_on_creation
    Delayed::Job.enqueue(
      NewPostingNotifier.new(self.id,"New Posting by #{self.user.nickname}: #{self.title}", ADMIN_EMAIL_ADDRESS),
        { :run_at =>   Time.now()+(CONSTANTS['delay_new_posting_notifications'].to_i).seconds }
     )
  end  
  
end

