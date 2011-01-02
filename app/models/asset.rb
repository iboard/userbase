class Asset < ActiveRecord::Base
  belongs_to  :assetable, :polymorphic => true
  ASSET_PATH = "#{Rails.root}/public/system/assets"
  has_attached_file :asset,
                    :styles => lambda { |attachment| 
                      if attachment.instance_read(:content_type) =~ /image/
                        {  
                           :popup  => "800x600=",
                           :preview => "450x325=",
                           :medium => "300x300>",
                           :thumb  => "100x100>",
                           :icon   => "64x64" 
                        } 
                      else 
                        {} 
                      end 
                    }

end
