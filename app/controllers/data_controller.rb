class DataController < ApplicationController
  
  def posts
    user_id = params[:user_id]
    
    facebook_service = Service.where("user_id = ? AND name = ?", user_id, "facebook").first()
    
    if (facebook_service.nil?)
      render :json => "{\"error\":\"Data Not Found\"}"
      return
    end
    
    graph = Koala::Facebook::API.new(facebook_service.token)
  
    posts = graph.get_connections('me', 'posts')
    
    render :json => posts
  end
end
