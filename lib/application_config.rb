module ApplicationConfig
  
  def uration(what)
    s=$APPLICATION_CONFIGURATION.send(what)
    if s.class == String
      s.html_safe
    else
      s 
    end
  end
  
  class ApplicationConfiguration
        
    attr_reader :application_name, :foot_menu, :application_css
    
    def initialize
      @application_name = load_config(:application_name)
      @foot_menu        = load_config(:foot_menu)
      @application_css  = load_config(:application_css)
    end
    
    def load_config(what)
      fn=File::join([File::dirname(__FILE__),'..','config',"#{what}.conf"])
      begin
        f = File::open(fn,'r')
        rc = f.read.strip.html_safe
        f.close
      rescue => e
        rc = "Please define your application name in "+
          "<code>config/#{what}.conf</code> "+
          "<br/>Error: #{e.inspect}".html_safe
      end
      rc
    end
      
  end
  
  $APPLICATION_CONFIGURATION = ApplicationConfiguration.new
  
end

include ApplicationConfig
