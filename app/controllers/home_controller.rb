class HomeController < ApplicationController
  
  def index
    @service_hash = {}
    @services = Service.all()
    
    for service in @services
      @service_hash[service.name] = true
    end
  end
end
