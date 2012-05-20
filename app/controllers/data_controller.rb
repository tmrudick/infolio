#!/usr/bin/env ruby
require "word_counter.rb"

class DataController < ApplicationController
  @@maxTime = 763
  
  def posts
    user_id = params[:user_id]
    
    facebook_service = Service.where("user_id = ? AND name = ?", user_id, "facebook").first()
    
    if (facebook_service.nil?)
      render :json => "{\"error\":\"Data Not Found\"}"
      return
    end
    
    graph = Koala::Facebook::API.new(facebook_service.token)
  
    posts = graph.get_connections('me', 'statuses', { 'since' => @@maxTime.days.ago })
    
    render :json => posts
  end
  
  def photos
    user_id = params[:user_id]
    
    facebook_service = Service.where("user_id = ? AND name = ?", user_id, "facebook").first()
    
    if (facebook_service.nil?)
      render :json => "{\"error\":\"Data Not Found\"}"
      return
    end
    
    graph = Koala::Facebook::API.new(facebook_service.token)
  
    posts = graph.get_connections('me', 'photos', { 'since' => @@maxTime.days.ago })
    
    render :json => posts
  end
  
  def profilePic
    user_id = params[:user_id]
    
    facebook_service = Service.where("user_id =? AND name = ?", user_id, "facebook").first()
    
    if (facebook_service.nil?)
      render :json => "{\"error\":\"Data Not Found\"}"
      return
    end
    
    graph = Koala::Facebook::API.new(facebook_service.token)
  
    profilePic = graph.get_picture('me', :type => 'large')
    
    redirect_to profilePic
  end
  
  def places
    user_id = params[:user_id]
    
    facebook_service = Service.where("user_id = ? AND name = ?", user_id, "facebook").first()
    
    if (facebook_service.nil?)
      render :json => '{"error":"Data Not Found"}'
      return
    end
    
    graph = Koala::Facebook::API.new(facebook_service.token)
    
    fb_places = graph.get_connections('me', 'checkins', { 'since' => @@maxTime.days.ago })
    
    places = []
    for place in fb_places
      begin
        p = Place.new
        p.message = place['message']
        p.timestamp = place['created_time']
        
        p.name = place['place']['name']
        p.latitude = place['place']['location']['latitude']
        p.longitude = place['place']['location']['longitude']
        p.city = place['place']['location']['city']
        p.state = place['place']['location']['state']
        p.country = place['place']['location']['country']
      
        places << p
      rescue
      end
    end
    
    foursquare_service = Service.where("user_id = ? AND name = ?", user_id, "foursquare").first()
    
    client = Foursquare2::Client.new(:oauth_token => foursquare_service.token)
    foursquare_places = client.user_checkins
    for place in foursquare_places["items"]
      begin
        p = Place.new
        p.name = place["venue"]["name"]
        p.timestamp = place["createdAt"]
        p.latitude = place["venue"]["location"]["lat"]
        p.longitude = place["venue"]["location"]["lng"]
        p.city = place["venue"]["location"]["city"]
        p.state = place["venue"]["location"]["state"]
        p.country = place["venue"]["location"]["country"]
        
        places << p
      rescue
      end
    end

    render :json => places
  end

  def words
    user_id = params[:user_id]
    facebook_service = Service.where("user_id = ? AND name = ?", user_id, "facebook").first()
    
    if (facebook_service.nil?)
      render :json => "{\"error\":\"Data Not Found\"}"
      return
    end
    
    graph = Koala::Facebook::API.new(facebook_service.token)
  
    posts = graph.get_connections('me', 'statuses', { 'since' => @@maxTime.days.ago })
    
    messages = []
    posts.each {|p| messages << p["message"]}

    frequency_table = WordCounter.new(messages).sorted_table
    
    render :json => frequency_table
    
  end
end
