class ProcessGallery < Struct.new( :gallery_id )
   
    def perform
      @gallery = Gallery.find(gallery_id)
      @zipfiles = @gallery.assets.where('asset_file_name like ?', '%zip').all
      
      @zipfiles.each do |zip|
        asset_filename = zip.asset.path;
        `(test -d tmp/gallery/#{@gallery.id} || mkdir -p tmp/gallery/#{@gallery.id}); unzip -j #{asset_filename} -d tmp/gallery/#{@gallery.id}/`
        
        Dir.glob(File.join("tmp/gallery/#{@gallery.id}/",'*')).each do |picture_path|
          if File.basename(picture_path)[0]!= '.' and !File.directory? picture_path
            asset = @gallery.assets.where(:asset_file_name => File.basename(picture_path)).first
            if !asset
              asset = @gallery.assets.create(:title=>File.basename(picture_path),:description=>'Extracted from'+asset_filename)
            end
            asset.asset = File.new(picture_path)
            asset.save
          end
        end
        @gallery.save
        `rm -rf tmp/gallery/#{@gallery.id}`
      end
    end
    
end
