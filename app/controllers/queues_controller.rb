class QueuesController < ApplicationController
  
  layout nil
  
  def index
    city_id = params[:city_id]    
    player = DB::Player.where(name: "Cor3y").first
    queues = LG::Queue.get city_id, player.id    
    render json: queues
  end

  # TODO: show only a particular queue
  #
  # def show
  #   
  # end
  
  def create
    # LG::Queue.create! ....
    render json: "ok|fail"
  end
  
  def destroy
    # LG::Queue.destroy
  end
  
end