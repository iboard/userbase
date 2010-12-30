atom_feed(:url => feed_path) do |feed|
   feed.title(APPLICATION_CONFIG['rss_title'])

   feed.updated(@commentables.first ? @commentables.first.created_at : Time.now.utc )
   for item in @commentables
     feed.entry(item) do |entry|
       entry.title(item.object_title)
       content = sanitize(RedCloth.new(item.body).to_html)
       if defined? item.assets
         content += render( :partial => "/assets/asset.html.erb", :collection => item.assets, :type => :html).to_s
       end
       entry.content( content, :type => :html)
       entry.updated item.updated_at
       entry.author(item.user.nickname)
     end
   end
end