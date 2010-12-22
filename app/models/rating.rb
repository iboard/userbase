class Rating < ActiveRecord::Base

  belongs_to :user
  belongs_to :rateable, :polymorphic => true, :counter_cache => true 
  
  after_save :update_average
  
  private
  
  # Update Average on 'rateable' without updating the timestamps for rateable
  # Called as 'after_save'-filter
  def update_average
    self.rateable.ratings_average = self.rateable.ratings.where('rating > ?', 0.0 ).average(:rating) || 0
    self.rateable.class.record_timestamps = false
    self.rateable.save!
    self.rateable.class.record_timestamps = true
  end
end
