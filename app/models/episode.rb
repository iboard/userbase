class Episode < ActiveRecord::Base

  is_blogable
  
  validates :title,       :presence => true
  validates :description, :presence => true
  validates :user_id,     :presence => true, :user_exists => true
  validates :access_read_mask, :numericality   => { :greater_than => 0 }
  validates :access_manage_mask, :numericality => { :greater_than => 0 }
  
  # make it translateable TODO: Move to a module
  has_many :translations, :as => :translateable
  scope :with_locale, lambda { |loc| where(:locale => loc.locale) }
  scope :with_locales, lambda { |loc| where( "locale in (?)", loc) }
  
  
  # Return the description as body for rss-feed (Commentable)
  def body
    description
  end

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
  
  def is_youtube_video?
    video_web_url.downcase.include?('http://www.youtube.com/')
  end
  
  def youtube_embed_url
    video_web_url.gsub("http://www.youtube.com/watch?v=",
      "http://www.youtube.com/v/"
    )
  end
  
end
