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
    # queue = DB::Queue::Building.first
    # queue.start 1
    queue = LG::Queue::BuildingQueue.new
    definition = DB::Structure::Definition.first
    level = 1
    response = queue.add_item city, definition, level
    response = { error: { message: "error creating a queue" }} if response.nil?
    render json: response
  end
  
  def destroy
    queue_item = LG::Queue::CityQueue.get params[:city_id], params[:player_id]
    
    type = sanitize_queue_type params[:type].to_sym
    success = queue_item.destroy_queue_item type, params[:object_id], params[:level_or_number].to_i
    response = if success
      { success: true }
    else
      { error: { message: "error destroying queue" }} 
    end
    render json: response
  end
  
  protected
  
  def sanitize_queue_type(type)
    case type
    when :building
      return :building
    when :struct
      return :building
    when :tech
      return :research
    when :research
      return :research
    when :unit
      return :unit
    else
      raise ArgumentError, "Need type to be in [:building, :struct, :tech, :research, :unit]".inspect
    end
  end
  
end