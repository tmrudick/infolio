class HomeController < ApplicationController
  before_filter :require_user, :only => [:loggedin]
  
  def index
    
  end
  
  def loggedin
    render :text => "Logged in!"
  end
end
