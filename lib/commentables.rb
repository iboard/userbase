#
#  This Module provides a global function 'all' to fetch all records of all models which are
#  registered with 'register(model_name)' before and their comments.
#
#  The submodule 'Commentable' is injected to ActiveResource and provides the method 'is_commentable'
#  which injects the InstanceModule-methods of this module
#
module Commentables
  
  # Load Library when included (see initializers/iboard_modules.rb)
  def self.included(base)
    ActiveRecord::Base.class_eval { include Commentables::Commentable }
  end
 
  # Return all records of all registered Commentable-Models and their comments
  # The list will be build from scratch if it's older than ::RSS_FEED_CACHE_TIME seconds.
  # Otherwise a cached version of the list will be returned. 
  def all_commentables(user=nil) 
    return @commentables if defined?(@commentables) && ((Time.now-@last_fetched).to_i < CONSTANTS['rss_feed_cache_time'].to_i)
    Rails.logger.info("**** Rebuilding rss-items for #{$registered_commentables.inspect} and comments")
    resources = $registered_commentables.map { |commentable_model|
      commentable_model.readable( user ? user.roles_mask : 1).all
    }.flatten
    comments = []
    resources.each do |resource|
      if resource.respond_to?('comments')
        resource.comments.each do |comment|
          comments << comment
        end
      end
    end
    
    @commentables = (resources+comments).reject {|r| r.nil? || (r.is_a?(Array) && r.empty?)  }.sort { |a,b|
      a.updated_at <=> b.updated_at 
    }
    @last_fetched = Time.now
    @commentables
  end
  
  def group_by_month
    return @archive_links if defined?(@archive_links) && ((Time.now-@last_fetched_archive).to_i < CONSTANTS['rss_feed_cache_time'].to_i)
    resources = []
    $registered_commentables.each do |resource|
      resources << resource.all(
         :select => 'id,created_at'
      ).group_by { |c| 
           [c.created_at.year,c.created_at.month].join('_') 
      }
    end
    @last_fetched_archive = Time.now
    @archive_links = resources.flatten
  end
  
  # Register a Model to be a 'Commentable'
  def register(arg)
    return if defined? $registered_commentables
    unless defined? $stage_commentables
      $stage_commentables = []
    end
    if arg.is_a?(String)
      commentables = [ arg ]
    else
      commentables = arg
    end
    arg.each do |commentable| 
      $stage_commentables << commentable unless $stage_commentables.include?(commentable)
    end
  end
  
  # Freeze and activate the list of registered models
  # (Call register('modelname') during application starting. When done call freeze_registered_commentables)
  def freeze_registered_commentables
    $registered_commentables ||= $stage_commentables
    puts(
       ("[%s] INFO  Registered commentables are frozen at "+
       "#{$registered_commentables.map {|m| m.to_s}.join(', ')}") % Time.now.strftime("%Y-%m-%d %H:%M:%S")
    ) if Rails.env != 'production'
  end
  
  
  #
  # Module Commentable - ActiveResource Injections
  #
  module Commentable

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def is_commentable
        class_eval <<-EOV
          include Commentables::Commentable::InstanceMethods
          has_many   :comments, :as => :commentable, :dependent => :destroy
          scope :readable, lambda { |roles_mask| 
            {
              :conditions => ["access_read_mask & ? > 0", roles_mask] 
            }
          }
        EOV
      end
      alias_method :is_commentable?, :is_commentable
      
      def group_by_month
        class_eval <<-EOV
          
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

