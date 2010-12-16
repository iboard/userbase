class Asset < ActiveRecord::Base
  belongs_to  :assetable, :polymorphic => true
  ASSET_PATH = "#{Rails.root}/public/system/assets"
  has_attached_file :asset
end
