class AddRatingCacheFieldToPosting < ActiveRecord::Migration
  def self.up
    add_column :postings, :ratings_count, :integer, :default => 0
    add_column :postings, :ratings_average, :float, :default => 0.0
    
    Posting.reset_column_information
    Posting.all.each do |u|
      u.ratings_count    =  Rating.where(['rateable_id=? and rateable_type=?',u.id,'Posting']).count
      u.ratings_average  =  Rating.where(['rateable_id=? and rateable_type=?',u.id,'Posting']).average('rating')
      u.save
    end

  end

  def self.down
    remove_column :postings, :ratings_count
    remove_column :postings, :ratings_average
  end
end
