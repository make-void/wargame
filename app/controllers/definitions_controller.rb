class DefinitionsController < ApplicationController

  
  layout nil
  
  def index
    resources = {}
    klasses.each do |cla|
      model = eval("DB::#{klass(cla)}::Definition")
      name = cla.downcase()
      resources[name] = model.all
    end
    render json: resources
  end
  
  def show
    @type = params[:type].to_sym
    filter_bad_intentions
    model = eval("DB::#{klass(@type)}::Definition")
    resources = model.all
    render json: resources
  end
  
  private
  
  def forbidden
    raise ActionController::RoutingError.new "Forbidden" # 403
  end
  
  def filter_bad_intentions
    forbidden unless LG::Queue::CityQueue::NAMES.keys.include? @type
  end
  
  def klasses
    LG::Queue::CityQueue::NAMES.keys.each do |name|
      klass name
    end
  end
  
  def klass(type)
    LG::Queue::CityQueue::NAMES.fetch(type).fetch(:klass).to_s.camelcase
  end
  
end