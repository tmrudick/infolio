class HomeController < ApplicationController
  before_filter :require_user
  
  def index
    @service_hash = {}
    @services = Service.where('user_id = ?', current_user.id)
    
    for service in @services
      @service_hash[service.name] = true
    end
  end
end
