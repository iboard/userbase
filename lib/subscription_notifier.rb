class SubscriptionNotifier < Struct.new( :subscription_id )
   
    def perform      
      subscription = Subscription.find(subscription_id)
      blog_entries = subscription.matching_blog_entries(subscription.user,subscription.last_notified_at)
      if blog_entries.any?
        UserMailer::send_subscription_notification(subscription,blog_entries).deliver
      end
    end
    
end

