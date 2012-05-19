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
  
  def places
    facebook_service = Service.where("name = ?", "facebook").first()
    
    if (facebook_service.nil?)
      render :json => '{"error":"Data Not Found"}'
      return
    end
    
    graph = Koala::Facebook::API.new(facebook_service.token)
    
    raw_places = graph.get_connections('me', 'checkins')
    
    places = []
    for place in raw_places
      begin
        p = Place.new
        p.message = place['message']
        
        p.name = place['place']['name']
        p.latitude = place['place']['location']['latitude']
        p.longitude = place['place']['location']['longitude']
        p.message = place['message']
      
        places << p
      rescue
      end
    end

    render :json => places
  end
end
