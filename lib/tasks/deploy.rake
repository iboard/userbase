namespace :deploy do
  
  desc "Run all test (rake:test + cucumnber) and parse output"
  task :test_all => :environment do
    puts "==================================" + "="*Rails.env.to_s.length
    puts "RUNING ALL TESTS AND CUCUMBER FOR #{Rails.env}"
    puts "==================================" + "="*Rails.env.to_s.length
    
    tests = [  
      { :cmd => 'rake test:units', :filter => /skips$/ },
      { :cmd => 'rake test:functionals', :filter => /skips$/ },
      { :cmd => 'bundle exec cucumber', :filter => /\d+ (scenarios|steps) \(\d+/ }
    ]
    
    max_prefix = tests.max{ |a,b| a[:cmd].length <=> b[:cmd].length }[:cmd].length 
    tests.each do |definition|
      print "%-#{max_prefix}.#{max_prefix}s" % definition[:cmd]
      print ": "
      begin
        p = File::popen( definition[:cmd], "r")
        puts p.read.split("\n").collect { |l| l if l.match definition[:filter] }.reject { |r| 
          r.nil? 
        }.join( "\n"+" "*max_prefix+": ").gsub(/,/,"\t")
        p.close
      rescue => e
        puts "Can't run command #{definition[:cmd]} -- #{e.message}"
      end
    end
    puts ""
  end
  
  desc "Dump Database to db/dump/today_%H.sql and move today to yesterday if exists"
  task :dump_db  => :environment do
    cfg = Rails.configuration.database_configuration[Rails.env]
    ts  = Time.now.strftime("%H")
    path = "#{Rails.root}/db/dump"
    output_file = "#{path}/today_#{ts}.#{Rails.env.to_s}.sql" 
    
    # Move outputfile  *today* -> *yesterday*
    `test -f #{output_file} && mv #{output_file} #{output_file.gsub(/today/,'yesterday')}`
    
    # dump the database
    case cfg['adapter']
    when 'mysql'
      `mysqldump -u #{cfg['username']} -p#{cfg['password']} #{cfg['database']} > #{output_file}`
    when 'sqlite3'
      `sqlite3  #{Rails.root}/#{cfg['database']} .dump  > #{output_file}` 
    else
      puts "** ERROR *** unknown adapter in #{cfg.inspect}"
    end
    `test -f #{output_file} && chmod 600 #{output_file}`
  end 
  
  desc "Update RDocs"
  task :rdoc => :environment do
    `bundle exec rdoc -W "http://github.com/iboard/userbase/blob/master/%s" -t "userbase - iboard.cc"`
  end
  
  desc "Sync database and assets from Production Server to development.sqlite3"
  task :sync_production_db => :environment do
     `rsync -avze ssh alta@r3.iboard.cc:/home/alta/altendorfer/db/production.sqlite3 db/development.sqlite3`
     `rsync -avze ssh alta@r3.iboard.cc:/home/alta/altendorfer/public ./`
  end
  
  
  desc "Fix rating cache"
  task :fix_ratings_cache => :environment do
    Posting.all.each do |p|
      p.ratings_count = p.ratings.count
      p.ratings_average = p.ratings.average(:rating) || 0.0
      puts "UPDATED CACHE VALUES #{p.id}: #{p.ratings_count}, #{p.ratings_average}"
      p.save!
    end
  end
  
  desc "Fix blog_entries index"
  task :fix_blog_entries => :environment do
    BlogEntry.delete_all
    Posting.all.each do |p|
      BlogEntry.create(:blog_entry_id => p.id, :blog_entry_type => 'Posting')
    end
    Episode.all.each do |e|
      BlogEntry.create(:blog_entry_id => e.id, :blog_entry_type => 'Episode')
    end
  end
  
end