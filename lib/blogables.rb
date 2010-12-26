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
  
  def blog_entries(user,blog_order,blog_dir)
    entries_by_model = $registered_commentables.map { |resource|
      resource.readable( user ? user.roles_mask : 1).all
    }.flatten.reject {|r| r.nil? }.sort { |a,b| 
      compare_blog_entries(a,b,blog_order) 
    }
    entries_by_model.reverse! if blog_dir == 'desc'
    entries_by_model
  end
  
  def filtered_by(user,blog_order,blog_dir,&block)
    entries_by_filter = blog_entries(user,blog_order,blog_dir).reject { |r|
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
          
          def image_asset_url
            if self.assets.any?
              first_image = self.assets.where( "asset_content_type like ?", "%image%" ).first
              first_image.asset.url if first_image
            end
          end
          
          private
          def create_blog_entry
            BlogEntry.create(:blog_entry_id => self.id, :blog_entry_type => self.class.to_s)
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

