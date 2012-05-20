class PagesController < ApplicationController
  def index
    user_id = params[:user_id]
    @services = Service.where("user_id = ?", user_id).collect { |item| item.name }
  end
end
