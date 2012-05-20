#!/usr/bin/env ruby
require "word_counter.rb"

class DataController < ApplicationController
  
  def posts
    user_id = params[:user_id]
    
    facebook_service = Service.where("user_id = ? AND name = ?", user_id, "facebook").first()
    
    if (facebook_service.nil?)
      render :json => "{\"error\":\"Data Not Found\"}"
      return
    end
    
    graph = Koala::Facebook::API.new(facebook_service.token)
  
    
  
    posts = graph.get_connections('me', 'statuses', { 'since' => 63.days.ago })
    
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
  
    posts = graph.get_connections('me', 'photos', { 'since' => 63.days.ago })
    
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
    
    raw_places = graph.get_connections('me', 'checkins', { 'since' => 63.days.ago })
    
    places = []
    for place in raw_places
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

    render :json => places
  end

  def words

    facebook_service = Service.where("name = ?", "facebook").first()
    
    if (facebook_service.nil?)
      render :json => "{\"error\":\"Data Not Found\"}"
      return
    end
    
    graph = Koala::Facebook::API.new(facebook_service.token)
  
    posts = graph.get_connections('me', 'statuses', { 'since' => 63.days.ago })
    
    messages = []
    posts.each {|p| messages << p["message"]}

    frequency_table = WordCounter.new(messages).sorted_table
    
    render :json => frequency_table
    
  end
end
