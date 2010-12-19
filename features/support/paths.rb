module NavigationHelpers
   
  # We are using UTF-8 ✔

  def path_to(page_name)
    
    case page_name
    when /the home page/
      '/'
    when /sign_in/
      '/users/sign_in'
    when /first posting page/
      '/users/1/postings/1'
    when /first episode page/
      '/users/1/episodes/1'
    when /users page/
      '/users'
    when /the rss feed/
      '/feed.atom?'+Time.now.to_i.to_s
    when /the archive for "([^"]*)"/
      '/archive/'+$1
    when /edit user page for "([^"]*)"/
      begin
        username = $1
        user = User.find_by_email(username)
        "/users/#{user.id}/edit"
      rescue Object => e
        raise "Can't find user #{username}"
      end
    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "With the following path_components \"#{path_components.inspect}\"\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
