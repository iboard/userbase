class WelcomeController < ApplicationController

  respond_to :html, :xml, :builder

  # GET /
  # GET /feed.atom
  def index
    @postings     = Posting.readable( current_user ? current_user.roles_mask : 1).latest(NUM_POSTINGS_ON_WELCOME_PAGE)
    respond_to do |format| 
      format.atom  { 
        @commentables = Commentable.all_commentables
        render :builder => @commentables 
      }
      format.html    
      format.xml  { render :xml => @postings }
    end
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
