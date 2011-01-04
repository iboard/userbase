namespace :application do
  
  desc "display the roles mask table"
  task :display_roles_mask => :environment do
    
    print "MASK: "
    User::ROLES.each do |role|
      print "%9s" % role
      print " | "
    end

    puts ""

    (0..255).each do |roles_mask|
      print "%03d : " % roles_mask
      User::ROLES.each do |role|
        print "    %s    " % ((roles_mask.to_i & 2**User::ROLES.index(role.to_s)) > 0 ? "X" : "-")
        print " | "
      end
      puts ""
      all = true
      User::ROLES.each do |role|
        unless roles_mask.to_i & 2**User::ROLES.index(role.to_s) > 0 
          all = false
          break
        end
      end
      break if all
    end
  end
  
  desc "Display short roles map"
  task :roles => :environment do
    (0..255).to_a.in_groups_of(4) do |g|
      (0..3).each do |grp_idx|
        roles_mask = g[grp_idx]
        print "%3d : " % g[grp_idx]
        User::ROLES.each do |role|
          print "%s" % ((roles_mask.to_i & 2**User::ROLES.index(role.to_s)) > 0 ? role[0].to_s : "-")
        end
        @all = true
        User::ROLES.each do |role|
          unless roles_mask.to_i & 2**User::ROLES.index(role.to_s) > 0 
            @all = false
            break
          end
        end
        print " | "
        break if @all
      end
      puts ""
      break if @all
    end
    puts " (Roles = #{User::ROLES.join(',')})"
  end
  
  desc "Show Notes"
  task :notes => :environment do
    puts "NOTES IN rb-FILES"
    system "find #{Rails.root} -type f -name *.rb -exec grep -hn NOTE: {} \\;"
  end
  
  desc "Show Todos"
  task :notes => :environment do
    puts "TODOS IN rb-FILES"
    system "find #{Rails.root} -type f -name *.rb -exec grep -hni TODO: {} \\;"
  end
end