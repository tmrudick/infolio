class OauthController < ApplicationController
  before_filter :require_user
  
  def facebook
    oauth = Koala::Facebook::OAuth.new
    redirect_to oauth.url_for_oauth_code(:permissions => "offline_access,user_about_me,user_status,")
  end
  
  def facebook_callback
    oauth = Koala::Facebook::OAuth.new
    
    access_token = oauth.get_access_token(params[:code])
    
    service = Service.where("user_id = ? AND name = ?", current_user.id, "facebook").first()
    
    if (service.nil?)
      service = Service.new
      service.name = "facebook"
      service.user_id = current_user.id
    end
    
    service.token = access_token
    service.save!

    redirect_to :controller => 'home', :action => 'loggedin'    
  end
end
