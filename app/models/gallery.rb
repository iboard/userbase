class Gallery < ActiveRecord::Base

   is_blogable
   validates :body,    :presence => true

   def play_button
      "gallery_popup(3000,'"+
      assets.where("asset_content_type like ?",'%image%').all.map {|a|
        a.asset.url(:popup)
      }.join(",")+
      "')"
   end
   
   def num_items
     assets.where("asset_content_type like ?",'%image%').count
   end
   
   def content
     :photo
   end
end
