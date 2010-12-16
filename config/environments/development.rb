Userbase::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # Mailersetup
  config.action_mailer.raise_delivery_errors = true
  
  
  ActionMailer::Base.smtp_settings = {  
    :address              => MAILSERVER_ADDRESS,  
    :port                 => MAILSERVER_PORT,  
    :domain               => MAILSERVER_DOMAIN,  
    :user_name            => MAILSERVER_USERNAME,  
    :password             => MAILSERVER_PASSWORD,  
    :authentication       => "plain",  
    :enable_starttls_auto => false  
  }
    
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  config.active_support.deprecation = :stderr
  
  Paperclip.options[:command_path] = "/opt/local/bin"
  #Paperclip.options[:swallow_stderr] = false 
    
end  



