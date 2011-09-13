class CitiesController < ApplicationController
  
  layout nil
  
  def index
    player = DB::Player.where(name: "Cor3y").first
    cities = LG::City.all player
    render json: cities
  end
  
  def show 
    data = LG::City.get params[:city]
    data = { error: { type: "not_found", message: "City not found (#{params[:city]})" } } unless data
    render json: data
  end
  
end