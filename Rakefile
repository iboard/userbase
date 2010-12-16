# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

#require 'darkfish-rdoc'
#
#Rake::RDocTask.new do |rdoc|
#    rdoc.title    = "MyFantasticLibrary - a library of utter fantasticness"
#    rdoc.rdoc_files.include 'README'
#
#    rdoc.options += [
#        '-SHN',
#        '-f', 'darkfish',  # This is the important bit
#      ]
#end


Userbase::Application.load_tasks

