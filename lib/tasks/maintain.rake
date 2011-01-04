namespace :maintain do
  
  desc "Send subscription mails"
  task :send_subscription_summaries => :environment do
    Subscription.where(:notify => true).all.each do |subscription|
      subscription.deliver_notifications(subscription.user)
    end
  end
  
  
end