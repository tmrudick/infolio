class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user
  
  def requires_auth
    if (session[:user].nil?)
      if (request.format == 'text/html')
        redirect_to :controller => 'oauth', :action => 'facebook'
      else
        render :text => "{ 'error': 'Not authorized' }", :status => :unauthorized
      end
    end
  end
  
  def current_user
    return session[:user]
  end
  
  def set_user(user)
    session[:user] = user
  end
  
  def clear_user
    session[:user] = nil
  end
end
