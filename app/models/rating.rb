class Rating < ActiveRecord::Base
  belongs_to :user
  belongs_to :rateable, :polymorphic => true, :counter_cache => true 
  
  after_save :update_average
  
  private
  def update_average
    self.rateable.ratings_average = self.rateable.ratings.average(:rating) || 0
    self.rateable.class.record_timestamps = false
    self.rateable.save!
    self.rateable.class.record_timestamps = true
  end
end
