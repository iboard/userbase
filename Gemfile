source 'http://rubygems.org'


############################################################################################
# System Gems
############################################################################################
#gem 'rails', '3.0.0.rc2'
gem 'rails'
gem 'sqlite3-ruby', :require => 'sqlite3'
gem 'mysql'
gem 'jquery-rails'  
gem 'mail'


############################################################################################
# 3rd party gems
############################################################################################
gem "dynamic_form"  # bring back errors_for-helper
gem "paperclip" #, :branch => 'rails3'
gem "will_paginate"
gem "RedCloth"
gem 'acts-as-taggable-on'
gem 'delayed_job'



# Authentication
gem "devise", ">=1.1.2"
gem "omniauth"
gem 'mongrel', '1.2.0.pre2'
gem "cancan"   

############################################################################################
# My own local gems
############################################################################################
# gem 'layout_helper', :git => 'http://dav.iboard.cc/git/layout_helper/'
# gem "layout_helper", :git => "git://github.com/iboard/layout_helper.git"
# Moved to local module until all functions are finalized


############################################################################################
# Bundle gems for certain environments:
############################################################################################
group :development do
  gem "rails-erd"
  gem "nifty-generators"
  gem 'rdoc'
end

group :test do
  gem 'json_pure'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'cucumber-rails'
  gem 'cucumber'
  gem 'rspec', '>=2.0.0.beta.13'
  gem 'rspec-rails', '>=2.0.0.beta.5'
  gem 'spork'
  gem 'launchy'
  gem 'factory_girl'
  gem 'escape_utils'
  gem 'ZenTest'
  gem 'autotest'
  gem 'autotest-rails'
end

