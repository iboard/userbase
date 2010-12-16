# Rails 3 Project: 'userbase'

This RAILS3 application may be used as a starting-point for your application.
It defines MVCs for

    - User (with devise, cancan, omniauth)
    - Postings with multiple attachments
    - Episodes to embed HTML5- and YouTube videos

# Getting Started

## Clone from Github

    git clone git://github.com/iboard/userbase.git [PATH_OF_YOUR_CHOICE]
    
## Configuration

Copy sample configuration files to live files

    cp config/mailserver_setting.rb.sample \
    config/mailserver_setting.rb
    

do the same thing with all *sample-files and edit this files to fit your needs

Most of the configuration can be done in 'config/application.yml' for each environment.

## In order to use rake taks deploy:dump_db

    mkdir db/dump

# Customize


## Static Pages
create the following files in public/static_pages

  - header.html ... used at top of application.html.erb
  - prefix.html ... displayed at top of application.html.erb
  - welcome_right.html ... displayed at the right sidebar of application.html.erb
  - footer.html ... used at the bottom of application.html.erb
  - about.html  ... displayed with welcome#about
  - episodes.html ... displayed at top of episodes#index
  - legal.html ... displayed at welcome#leagal
  - welcome_activity.html ... displayed at welcome#index

There is no need to restart the server when you make changes in this files.

## Bundle

    bundle install
    
## Create the database

    rake db:migrate

## Start your engine

    rails server

Dec 14, 2010 - Andreas Altendorfer &lt;andreas@altendorfer.at&gt;

## More Information

- [Blog and online installation of _userbase_](http://iboard.cc/postings/tag/userbase)
- [PivotalTracker](http://www.pivotaltracker.com/projects/168147)
