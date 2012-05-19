class OauthController < ApplicationController  
  def facebook
    oauth = Koala::Facebook::OAuth.new
    redirect_to oauth.url_for_oauth_code(:permissions => "user_about_me,user_status")
  end
  
  def facebook_callback
    oauth = Koala::Facebook::OAuth.new
    
    access_token = oauth.get_access_token(params[:code])
    
    service = Service.where("name = ?", "facebook").first()
    
    if (service.nil?)
      service = Service.new
      service.name = "facebook"
    end
    
    service.token = access_token
    service.save!

    redirect_to :controller => 'home', :action => 'index'    
  end

def twitter_callback
   
    
    service = Service.where("name = ?", "twitter").first()
    
    if (service.nil?)
      service = Service.new
      service.name = "twitter"
    end
    
    service.token = params[:token]
    service.save!

    redirect_to :controller => 'home', :action => 'index'    
  end


end
