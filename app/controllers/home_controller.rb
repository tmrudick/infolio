class HomeController < ApplicationController
  before_filter :require_user, :only => [:loggedin]
  
  def index    
  end
  
  def loggedin
    @services = Service.where('user_id = ?', current_user.id)
  end
end
