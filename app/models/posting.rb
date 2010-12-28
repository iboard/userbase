class Posting < ActiveRecord::Base

  is_blogable
      
  validates :title,   :presence => true
  validates :body,    :presence => true
  validates :user_id, :presence => true, :user_exists => true
  validates :access_read_mask, :numericality   => { :greater_than => 0 }
  validates :access_manage_mask, :numericality => { :greater_than => 0 }
  
  scope :latest, lambda { |num_postings| {:limit => num_postings, :order => 'updated_at desc'} }
  
  #Notifiers
  after_create :async_notify_on_creation


  # Virtual Attribute
  def access_read_mask_flags=(flags)
    self.access_read_mask=(flags & User::ROLES).map { |r| 2**User::ROLES.index(r) }.sum
  end
  
  # Virtual Attribute
  def access_manage_mask_flags=(flags)
    self.access_manage_mask=(flags & User::ROLES).map { |r| 2**User::ROLES.index(r) }.sum
  end

  def allow_role_to_read?(role)
    ! (2**User::ROLES.index(role) & access_read_mask).zero?
  end 
  
  def allow_role_to_manage?(role)
    ! (2**User::ROLES.index(role) & access_manage_mask).zero?
  end 

  def allow_user_to_read?(user)
    ! (user.roles_mask & access_read_mask).zero?
  end 
  
  def allow_user_to_manage?(user)
    ! (user.roles_mask & access_manage_mask).zero?
  end 

  private
  # Send an email to the owner/author of this posting
  def async_notify_on_creation
    Delayed::Job.enqueue NewPostingNotifier.new(self.id,"New Posting by #{self.user.nickname}: #{self.title}", ADMIN_EMAIL_ADDRESS)
  end  
  
end

