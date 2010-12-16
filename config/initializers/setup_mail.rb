ActionMailer::Base.smtp_settings = {
  :address              => MAILSERVER_ADDRESS,
  :port                 => MAILSERVER_PORT,
  :domain               => MAILSERVER_DOMAIN,
  :user_name            => MAILSERVER_USERNAME,
  :password             => MAILSERVER_PASSWORD,
  :authentication       => "plain",
  :enable_starttls_auto => true
}

ActionMailer::Base.default_url_options[:host] = DEFAULT_URL
Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?
