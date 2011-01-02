class BlogableGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  
  argument :resource_name, :type => :string

  def debug_generator
    puts "Generate a blogable named #{resource_name.camelize}"
    puts "Options: " +options.inspect
    puts "Resource Name: "+ARGV.shift.camelize+"/"+resource_name
    @arguments = []
    while f=ARGV.shift
      argument = f.split(':')
      @arguments << { :name => argument[0], :type => argument[1].to_sym }
    end
    puts "Arguments:  #{@arguments.inspect}"
  end
  
  def calling_scaffold
    puts "SCAFFOLDING #{resource_name.camelize}..."
    `rails generate scaffold #{resource_name.camelize} bloggable:integer #{@arguments.map{|a| a[:name]+":"+a[:type].to_s}.join(' ')}`
    `rm -f app/views/#{resource_name.pluralize.underscore}/* \
           app/controllers/#{resource_name.pluralize.underscore}_controller.rb \
           app/helpers/#{resource_name.pluralize.underscore}_helper.rb`
  end
  
  def patching_scaffold
    migration_path = File.join(Rails.root,'db/migrate/')
    migration = Dir.new(migration_path).detect {|e| 
      e.match(/[0-9]+_create_#{resource_name.pluralize.underscore}/) 
    }
    puts "PATCHING MIGRATION #{migration.inspect}"
    migration_source = File.new(File.join(migration_path,migration),'r').read.gsub(/t.integer :bloggable/) { |f|
    '## BLOGABLE GENERATOR ##
      t.integer  "user_id"
      t.string   "title"
      t.text     "body"
      t.integer  "access_read_mask",   :default => 4
      t.integer  "access_manage_mask", :default => 4
      t.string   "locale",             :default => "en"
      t.integer  "ratings_count",      :default => 0
      t.float    "ratings_average",    :default => 0.0
      ## /BLOGABLE GENERATOR ##
    '
    }
    f = File.new(File.join(migration_path,migration),"w")
    f << migration_source
    f.close
  end
  
  def patching_model
    model_file = File.join(Rails.root,'app/models',resource_name.singularize.underscore.downcase+'.rb')
     puts "PATCHING MODEL #{model_file}"
     source = File.new(model_file,'r').read.\
       gsub(/^end$/) {|f|
"
   is_blogable
   validates :body,    :presence => true

end"        
       }
     f = File.new(model_file,"w")
     f << source
     f.close 
  end
  
  def copy_templates
    @resource_single  = resource_name.singularize.underscore.downcase
    @resource_plural  = resource_name.pluralize.underscore.downcase

    view_path = "app/views/#{@resource_plural}"
    template "index.html.erb",     File::join(view_path,"index.html.erb")
    template "show.html.erb",      File::join(view_path,"show.html.erb")
    template "_blogable.html.erb", File::join(view_path,"_#{@resource_single}.html.erb")
    template "_blogable_body.html.erb",File::join(view_path,"_#{@resource_single}_body.html.erb")
    template "_blogable_fields.html.erb",File::join(view_path,"_#{@resource_single}_fields.html.erb")
    template "edit.html.erb",      File::join(view_path,"edit.html.erb")
    template "_form.html.erb",      File::join(view_path,"_form.html.erb")
    template "new.html.erb",       File::join(view_path,"new.html.erb")

    controller_path="app/controllers/"
    template "blogable_controller.rb", File::join(controller_path,"#{@resource_plural}_controller.rb")
    
    helper_path="app/helpers/"
    template "blogable_helper.rb", File::join(helper_path,"#{@resource_plural}_helper.rb")

    puts "*"*79
    puts "*** BLOGABLE #{@resource_single.camelize} GENERATED"
    puts ""
    puts "*** Edit app/views/#{@resource_plural}/_#{@resource_single}_body.html.erb"
    puts "*** DON'T FORGET TO CONFIGURE #{@resource_single.camelize} IN config/initializers/iboard_modules.rb"
    puts "*** something like " +"
      # Register commentables (should be moved to module Commentables on init)
      Commentable::register([Posting,Episode,...#{@resource_single.camelize}])
      Commentable::freeze_registered_commentables
"
    puts "*"*79
  end
end
