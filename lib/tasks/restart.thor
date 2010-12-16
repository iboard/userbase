class Application < Thor

  desc "restart [--worker_only]", "kill 'rake jobs:work' and 'touch tmp/restart.txt'"
  method_options :worker_only => :boolean
  def restart
    kill_pid("ps x|grep 'rake jobs:work'|grep -v grep")
    unless options[:worker_only]
      print "Touching tmp/restart.txt ... => "
      puts "OK" if system( "touch tmp/restart.txt" )
    end
  end
  
  
  private
  def kill_pid(cmd)
    p=File::popen(cmd, "r")
    if p
      tasks = p.read.strip
      if tasks.empty?
        puts "No worker found"
      else
        pid = tasks.split(" ").first
        print "worker is running with PID #{pid} - going to kill it ... => "
        killcmd = "kill #{pid}"
        puts "OK" if system(killcmd)
      end
      p.close
    else
      puts "CAN'T EXECUTE #{cmd}!"
    end
  end
  
end
