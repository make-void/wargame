class QueuesController < ApplicationController
  
  layout nil
  
  def show
    city_id = params[:city_id]    
    player = DB::Player.where(name: "Cor3y").first
    queue = LG::Queue.get city_id, player.id
    render json: queue
  end
  
  def create

  end
  
  def destroy
    
  end
  
end