class Translation < ActiveRecord::Base
  
  belongs_to :translateable, :polymorphic => true
  
  scope :translations_of, lambda { |type,id|
    where(:translateable_type => type,:translateable_id   => id)
  }
  
end
