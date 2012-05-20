class OauthController < ApplicationController  
  before_filter :requires_auth, :except => ['facebook', 'facebook_callback']
  
  def index
    @service_hash = {}
    @services = Service.all()
    
    for service in @services
      @service_hash[service.name] = true
    end
  end
  
  def logout
    clear_user()
    
    redirect_to root_url
  end
  
  def facebook
    oauth = Koala::Facebook::OAuth.new
    redirect_to oauth.url_for_oauth_code(:permissions => "user_about_me,user_status,user_photos")
  end
  
  def facebook_callback
    oauth = Koala::Facebook::OAuth.new
    
    access_token = oauth.get_access_token(params[:code])
    
    if current_user.nil?
      graph = Koala::Facebook::API.new(access_token)
      fb_user = graph.get_object('me')

      user = User.find_by_facebook_id(fb_user['id'])

      if (user.nil?)
        user = User.new
        user.facebook_id = fb_user['id']
        user.first_name = fb_user['first_name']
        user.last_name = fb_user['last_name']
        user.save!
      end
      
      set_user(user)
    end
    
    service = Service.where("user_id = ? AND name = ?", current_user.id, "facebook").first()
    
    if (service.nil?)
      service = Service.new
      service.name = "facebook"
      service.user_id = current_user.id
    end
    
    service.token = access_token
    service.save!

    redirect_to :action => 'index'    
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
