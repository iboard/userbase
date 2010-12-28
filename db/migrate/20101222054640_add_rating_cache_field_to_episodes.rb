class AddRatingCacheFieldToEpisodes < ActiveRecord::Migration
  def self.up
    add_column :episodes, :ratings_count, :integer, :default => 0
    add_column :episodes, :ratings_average, :float, :default => 0.0
    
    Episode.reset_column_information
    Episode.all.each do |u|
      u.ratings_count    =  Rating.where(['rateable_id=? and rateable_type=?',u.id,'episode']).count
      u.ratings_average  =  Rating.where(['rateable_id=? and rateable_type=?',u.id,'episode']).average('rating')
      u.save
    end

  end

  def self.down
    remove_column :episodes, :ratings_count
    remove_column :episodes, :ratings_average
  end
end
