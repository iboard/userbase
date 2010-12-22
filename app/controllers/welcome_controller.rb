class WelcomeController < ApplicationController

  respond_to :html, :xml, :builder

  # GET /
  # GET /feed.atom
  def index
    @postings     = Posting.readable( current_user ? current_user.roles_mask : 1).latest(CONSTANTS['num_postings_on_welcome_page'])
    respond_to do |format| 
      format.atom  { 
        @commentables = Commentable.all_commentables
        render :builder => @commentables 
      }
      format.html    
      format.xml  { render :xml => @postings }
    end
  end
  
  # GET /archive/:month
  def archive
    from_year  = params[:month].split("_")[0]
    from_month = params[:month].split("_")[1]
    from_date = Time.parse( "#{from_year}-#{from_month}-01 00:00:00")
    to_date   = from_date+1.month
    postings = Posting.readable( current_user ? current_user.roles_mask : 1).where( ['created_at between ? and ?',
      from_date, to_date])
    episodes = Episode.readable( current_user ? current_user.roles_mask : 1).where( ['created_at between ? and ?',
      from_date, to_date])
    @archive = (postings.all + episodes.all).sort { |a,b| a.created_at <=> b.created_at }
  end
  
  # GET /ratings
  def ratings
    postings = Posting.readable( current_user ? current_user.roles_mask : 1)
    episodes = Episode.readable( current_user ? current_user.roles_mask : 1)
    ratings = (postings.all + episodes.all).sort { |b,a| (a.ratings_average||0) <=> (b.ratings_average||0) }
    @ratings = ratings.paginate(:page => params[:page], :per_page => CONSTANTS['paginate_ratings_per_page'])
  end

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

  # Render User Settings page (devise)
  def user
  end
  
  # Just a static page
  def legal_notice
  end
  
  # Just a static page
  def about
  end
end
