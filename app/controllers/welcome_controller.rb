class WelcomeController < ApplicationController

  respond_to :html, :xml, :builder

  # GET /
  # GET /feed.atom
  def index
    @postings     = Posting.readable( current_user ? current_user.roles_mask : 1).latest(CONSTANTS['num_postings_on_welcome_page']).order('updated_at asc')
    respond_to do |format| 
      format.atom  { 
        @commentables = Commentable.all_commentables.sort {|a,b| a.updated_at <=> b.updated_at}
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
