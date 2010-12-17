class User < ActiveRecord::Base
  
  # Use remote database for user-model
  if USER_DATABASE['use_remote_database']
    self.establish_connection  USER_DATABASE['use_remote_database'].to_sym
  end
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  acts_as_tagger

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, 
    :remember_me, :roles, :authentication_token, :confirmation_token,
    :nickname, :avatar, :clear_avatar, :crop_x, :crop_y, :crop_w, :crop_h,
    :time_zone, :language, :use_gravatar
  
  # Roles
  ROLES = %w(guest staff admin moderator author)
  scope :with_role, lambda { |role| {:conditions => "roles_mask & #{2**ROLES.index(role.to_s)} > 0"} }
  
  # Associations  
  has_many :postings, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :episodes, :dependent => :destroy
  has_many :authentications, :dependent => :destroy
  
  #validations
  validates :nickname, :presence => true, :uniqueness => true
  
  # Avatar, paperclip
  has_attached_file :avatar, 
                    :styles => { 
                      :medium => "300x300>",
                      :thumb  => "100x100>",
                      :icon   => "64x64"
                    },
                    :processors => [:cropper]
 
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  after_update  :reprocess_avatar, :if => :cropping?
  
  
  # Notifiers
  after_create :async_notify_on_creation
  
  # Helper for post-processing
  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end
  
  def avatar_geometry(style = :original)
    paperclip_geometry avatar, style
  end
  
  def admin?
    User.all.any? ? (self == User.first || role?(:admin)) : true
  end

  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum
  end
  
  def roles
    ROLES.reject { |r| ((roles_mask || 0) & 2**ROLES.index(r)).zero? }
  end
  
  def role?(role)
    roles.include? role.to_s
  end
  
  def clear_avatar
    false
  end
  
  def clear_avatar=(new_value)
    self.avatar = nil if new_value == '1'
  end
  
  # omniAuth
  def apply_omniauth(omniauth)
    self.email = omniauth['user_info']['email'] if email.blank?
    apply_trusted_services(omniauth) if self.new_record?
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end

  def update_with_password(params={}) 
    if params[:password].blank? 
      params.delete(:password) 
      params.delete(:password_confirmation) if params[:password_confirmation].blank? 
    end 
    super
  end
  
  def avatar_url(mode)
    if self.use_gravatar
      "http://gravatar.com/avatar/#{gravatar_id}.png"
    else
      avatar.url(mode)
    end
  end

  private
  def reprocess_avatar
    avatar.reprocess!
  end
  
  def gravatar_id
    Digest::MD5.hexdigest(self.email.downcase)
  end
  
  def apply_trusted_services(omniauth)
    if self.nickname.blank?
      self.nickname = omniauth['user_info']['nickname'] unless omniauth['user_info']['nickname'].blank?
    end
    if self.email.blank?
      self.email = omniauth['user_info']['email'] unless omniauth['user_info']['email'].blank?
    end
    self.password, self.password_confirmation = String::random_string(42)
    self.confirmed_at, self.confirmation_sent_at = Time.now
  end

  def async_notify_on_creation
     Delayed::Job.enqueue NewUserNotifier.new(self.id,"NEW USER REGISTERED", ADMIN_EMAIL_ADDRESS)
  end  
        
end
