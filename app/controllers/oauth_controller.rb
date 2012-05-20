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

    redirect_to :controller => 'pages', :action => 'index', :user_id => current_user.id
  end
  
  def foursquare  
    client = OAuth2::Client.new('HG2PEZ3DEQDHHJC0NTKCLEGJLYGQY4D4BPOT3WCNRRLUBDSO', 'TUPOKWBTIYAPLEIRLXUR25TDY2VABCHMDPIGX5UJZUV3E3PD', { :site => 'http://www.foursquare.com', :authorize_url => '/oauth2/authenticate'})  
    
    redirect_to client.auth_code.authorize_url(:redirect_uri => 'http://localhost:3000/auth/foursquare/callback')
  end
  
  def foursquare_callback
    code = params[:code]
    
    client = OAuth2::Client.new('HG2PEZ3DEQDHHJC0NTKCLEGJLYGQY4D4BPOT3WCNRRLUBDSO', 'TUPOKWBTIYAPLEIRLXUR25TDY2VABCHMDPIGX5UJZUV3E3PD', { :site => 'http://foursquare.com/', :token_url => '/oauth2/access_token', :ssl => {:ca_path => Rails.root.join("/lib/curl-ca-bundle.crt").to_s}})  

    token = client.auth_code.get_token(code, :redirect_uri => 'http://localhost:3000/auth/foursquare/callback')
            
    service = Service.where("user_id = ? AND name = ?", current_user.id, "foursquare").first()
    
    if (service.nil?)
      service = Service.new
      service.name = "foursquare"
      service.user_id = current_user.id
    end
    
    service.token = token.token
    service.save!

    redirect_to :controller => 'pages', :action => 'index', :user_id => current_user.id
  end

def twitter_callback
    service = Service.where("name = ?", "twitter").first()
    
    if (service.nil?)
      service = Service.new
      service.name = "twitter"
    end
    
    service.token = params[:token]
    service.save!

    redirect_to :controller => 'pages', :action => 'index', :user_id => current_user.id
  end
end
