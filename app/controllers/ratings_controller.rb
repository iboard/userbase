class RatingsController < ApplicationController
  # GET /ratings
  def ratings
    postings = Posting.readable( current_user ? current_user.roles_mask : 1)
    episodes = Episode.readable( current_user ? current_user.roles_mask : 1)
    ratings = (postings.all + episodes.all).flatten.sort { |b,a| (a.ratings_average||0) <=> (b.ratings_average||0) }
    @ratings = ratings.paginate(:page => params[:page], :per_page => CONSTANTS['paginate_ratings_per_page'])
  end
  
  # GET /rate
  def rate
     @rateable = eval("#{params[:rateable_type]}.find(#{params[:rateable_id]})")
     @user     = User.find(params[:user_id])
     @my_rating = @user.ratings.where(
                    :rateable_id => params[:rateable_id].to_i, 
                    :rateable_type => params[:rateable_type]).first ||
                  @user.ratings.create(
                    :rateable_id => params[:rateable_id].to_i, 
                    :rateable_type => params[:rateable_type])
    @my_rating.rating = params[:rating].to_i
    @my_rating.save
    @rateable.reload
  end

end