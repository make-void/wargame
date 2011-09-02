class PlayersLocationsController < ApplicationController
  
  layout nil
  
  def index
    # TODO: currently it stops in the router, look in config/routes.rb
    
    # fields = [:alliance_id, :created_at, :email, :name, :player_id]
    # data = DB::Player.select(fields).where(name: "Cor3y").first.attributes
    # render json: data
  end
  
end