class PagesController < ApplicationController
  def index
    user_id = params[:user_id]
    
    @service_hash = {}
    @services = Service.where("user_id = ?", user_id)
    
    for service in @services
      @service_hash[service.name] = true
    end  end
end
