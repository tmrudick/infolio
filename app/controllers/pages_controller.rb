require "open-uri"

class PagesController < ApplicationController
  def index
    user_id = params[:user_id]
    
    @service_hash = {}
    @services = Service.where("user_id = ?", user_id)
    
    for service in @services
      @service_hash[service.name] = true
    end  
    
    @instaPhotos = instaPhotos()
    
    end
    
    def instaPhotos
		@tweets = Twitter.search("from:#{current_user.twitter} filter:links instagr.am", :include_entities=>true,  :rpp => 4, :type => "recent").map do |status|
 				((status.urls).map(&:expanded_url).flatten)  end  
				
  		instaResult = []		
  		@tweets.each do |p| 	
  			#p[0]
  			instaResult << open("http://api.instagram.com/oembed?url=#{p[0]}").read
  			
  				#parsed_json = ActiveSupport::JSON.decode(instaResult)
  				#image_tag("http://api.instagram.com/oembed?url=#{p[0]}") 
  			
  		end 
  	return instaResult
  end
    
end
