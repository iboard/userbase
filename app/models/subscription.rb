class Subscription < ActiveRecord::Base
  belongs_to :user
  
  validates_uniqueness_of :user_id, :scope => [:blogable_type,:tag_list]
  
  
  def matching_blog_entries(user=nil,since=nil)
    since ||= Time.new(1970)
    tags = self.tag_list.split(/,/).map{|t| t.strip}.reject{|r| r.blank?}
    
    unless self.blogable_type.blank?
      # Search by blogable_type (one resource)
      blogables = eval("#{self.blogable_type}.readable(#{user ? user.roles_mask : 1})."+
                       "where('updated_at > ?',since)").\
                      order("updated_at desc")
      if tags.any?
        blogables = blogables.tagged_with(tags,:any => true).order("updated_at desc")
      end
      blogables.all
    else
      # Collect from all resources
      blogables = Blogable::collect { |resource|
        if tags.any?
          resource.tagged_with(tags, :any => true).\
            readable(user ? user.roles_mask : 1).where('updated_at > ?',since).all
        else
          resource.readable(user ? user.roles_mask : 1).where('updated_at > ?',since).all
        end
      }.flatten.sort {|b,a| a.updated_at <=> b.updated_at }
    end
    
    
  end
  
  def deliver_notifications(user=nil)
    Delayed::Job.enqueue( SubscriptionNotifier.new(self.id) )
  end
end
