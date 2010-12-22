class Posting < ActiveRecord::Base

  is_commentable
  can_have_assets
  acts_as_taggable_on :tags
    
  belongs_to :user
  has_many   :ratings, :as => :rateable, :dependent => :destroy
  
  
  validates :title,   :presence => true
  validates :body,    :presence => true
  validates :user_id, :presence => true, :user_exists => true
  validates :access_read_mask, :numericality   => { :greater_than => 0 }
  validates :access_manage_mask, :numericality => { :greater_than => 0 }
  
  scope :latest, lambda { |num_postings| {:limit => num_postings, :order => 'updated_at desc'} }
  
  # make it translateable TODO: Move to a module
  has_many :translations, :as => :translateable
  scope :with_locale, lambda { |loc| where(:locale => loc.locale) }
  scope :with_locales, lambda { |loc| where( "locale in (?)", loc) }

  #Notifiers
  after_create :async_notify_on_creation


  # Virtual Attributes
  def access_read_mask_flags=(flags)
    self.access_read_mask=(flags & User::ROLES).map { |r| 2**User::ROLES.index(r) }.sum
  end
  
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
  def async_notify_on_creation
    Delayed::Job.enqueue NewPostingNotifier.new(self.id,"New Posting by #{self.user.nickname}: #{self.title}", ADMIN_EMAIL_ADDRESS)
  end  
  
end

