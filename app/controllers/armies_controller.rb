class ArmiesController < ApplicationController
  
  layout nil
  
  def index
    player = DB::Player.where(name: "Cor3y").first
    armies = LG::Army.all player
    render json: armies
  end
  
end