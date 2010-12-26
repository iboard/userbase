# Load the rails application
require File.expand_path('../application', __FILE__)

# Include mailserver_settings
require File.join(File.dirname(__FILE__),'mailserver_setting.rb')
require File.join(File.dirname(__FILE__),'omniauth_settings.rb')
require File.join(File.dirname(__FILE__),'..','lib','special_characters.rb')

# Initialize the rails application
Userbase::Application.initialize!
