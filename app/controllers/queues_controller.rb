class QueuesController < ApplicationController
  
  layout nil
  
  before_filter do # TODO: authentication
    @player = DB::Player.where(name: "Cor3y").first
  end
  
  def index
    city_id = params[:city_id]    
    queues = LG::Queue::CityQueue.get city_id, @player.id    
    render json: queues.get
  end

  # TODO: show only a particular queue
  #
  # def show
  #   
  # end
  
  def create
    # LG::Queue.create! ....
    city = DB::City.find params[:city_id]
    type = params[:type_id]
    structure = { city_id: city.id, structure_id: params[:id], player_id: @player.id}
    # queue = DB::Queue::Building.create! structure.merge( level: 0, time_needed: 0 )
    queue = DB::Queue::Building.first
    queue.start 1
    response = queue.attributes
    response = { error: { errorName: "Error: message" }} if response.nil?
    render json: response
  end
  
  def destroy
    # LG::Queue.destroy
  end
  
end