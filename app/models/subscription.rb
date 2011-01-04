class Subscription < ActiveRecord::Base
  belongs_to :user
  
  validates_uniqueness_of :user_id, :scope => [:blogable_type,:tag_list]
  
  
  def matching_blog_entries(user=nil,since=nil)
    since ||= Time.new(1970,1,1)
    unless self.blogable_type.blank? 
      eval("#{self.blogable_type}.readable(#{user ? user.roles_mask : 1}).where('updated_at > ?',since)")
    else
      Blogable::collect { |resource|
          unless self.tag_list.blank?
            resource.tagged_with(self.tag_list.split(/[,\s+]/).reject(&:blank?), :any => true).\
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
