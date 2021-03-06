#
#  This Module provides a global function 'all' to fetch all records of all models which are
#  registered with 'register(model_name)' before and their comments.
#
#  The submodule 'Commentable' is injected to ActiveResource and provides the method 'is_commentable'
#  which injects the InstanceModule-methods of this module
#
module Blogables
  
  # Load Library when included (see initializers/iboard_modules.rb)
  def self.included(base)
    ActiveRecord::Base.class_eval { include Blogables::Blogable }
  end
 
  # Return all records of all registered Commentable-Models and their comments
  # The list will be build from scratch if it's older than ::RSS_FEED_CACHE_TIME seconds.
  # Otherwise a cached version of the list will be returned. 
  def blog_models 
    $registered_commentables
  end
  
  def collect(&block)
    blog_models.map { |resource|
      yield(resource)
    }
  end
  
  def blog_entries(user,blog_order,blog_dir,language_filter=nil)
    entries_by_model = $registered_commentables.map { |resource|
      if language_filter
        resource.with_locales(language_filter).readable( user ? user.roles_mask : 1).all
      else
        resource.readable( user ? user.roles_mask : 1).all
      end
    }.flatten.reject {|r| r.nil? }.sort { |a,b| 
      compare_blog_entries(a,b,blog_order) 
    }
    entries_by_model.reverse! if blog_dir == 'desc'
    entries_by_model
  end
  
  def filtered_by(user,blog_order,blog_dir,language_filter,&block)
    entries_by_filter = blog_entries(user,blog_order,blog_dir,language_filter).reject { |r|
      yield(r)
    }
    entries_by_filter
  end
  
  def compare_blog_entries(a,b,order_by)
    order_by ||= 'ratings_average'
    if order_by == 'ratings_average'
      (a.ratings_average||0.0)  <=> ( b.ratings_average||0.0 )
    else
      a.send( order_by ) <=> b.send( order_by )
    end
  end

  #
  # Module Commentable - ActiveResource Injections
  #
  module Blogable

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def is_blogable
        class_eval <<-EOV
          belongs_to :user
          has_many   :ratings,   :as => :rateable, :dependent => :destroy
          has_one    :blog_entry, :as => :blog_entry, :dependent => :destroy
          is_commentable
          can_have_assets
          acts_as_taggable_on :tags
          def is_blog_model?
            true
          end
          
          after_create :create_blog_entry
          after_save   :clear_cache
          
          validates :title,   :presence => true
          validates :user_id, :presence => true, :user_exists => true
          validates :access_read_mask, :numericality   => { :greater_than => 0 }
          validates :access_manage_mask, :numericality => { :greater_than => 0 }
          
          scope :latest, lambda { |num_postings| {:limit => num_postings, :order => 'updated_at desc'} }
          
          def pictures
            assets.where("asset_content_type like ?", "%image%")
          end
          
          def image_asset_url(mode=:preview)
            if self.assets.any?
              first_image = self.assets.where( "asset_content_type like ?", "%image%" ).first
              if first_image
                first_image.asset.url(mode) 
              end
            end
          end

          # Translations
          has_many :translations, :as => :translateable, :dependent => :destroy
          scope :with_locale, lambda { |loc| where(:locale => loc.locale) }
          scope :with_locales, lambda { |loc| where( "locale in (?)", loc) }
          
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
          def create_blog_entry
            BlogEntry.create(:blog_entry_id => self.id, :blog_entry_type => self.class.to_s)
          end
          
          def clear_cache
            Rails.cache.delete('tags')
            Rails.cache.delete('archive_links')
          end
        EOV
      end
    end

    module InstanceMethods
      def object_title
        if defined?(title)
          title
        else
          "Please define a method title() for your class #{self.class.to_s}"
        end
      end

      def object_body
        if defined?(body)
          body
        else
          "Please define a method body() for your class #{self.class.to_s}"
        end
      end

      def author
        user.nickname || t(:anonymous)
      end
    end
  end
end

