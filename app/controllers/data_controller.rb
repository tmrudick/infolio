class DataController < ApplicationController
  
  def posts
    facebook_service = Service.where("name = ?", "facebook").first()
    
    if (facebook_service.nil?)
      render :json => "{\"error\":\"Data Not Found\"}"
      return
    end
    
    graph = Koala::Facebook::API.new(facebook_service.token)
  
    posts = graph.get_connections('me', 'statuses')
    
    render :json => posts
  end
end
