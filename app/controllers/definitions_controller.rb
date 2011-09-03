class DefinitionsController < ApplicationController
  
  NAMES = {
    # table => column
    structs: { klass: :structure }, 
    techs: { klass: :research, id_name: :tech }, #  FIXME: id_name is pathetic, rename all "structure_id" in "struct_id" pleaaaase! now! (also think about naming difference between tech,research and upgrades, with version control should be easy to rename)
    units: { klass: :unit },
  }
  
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
    forbidden unless NAMES.keys.include? @type
  end
  
  def klasses
    NAMES.keys.each do |name|
      klass name
    end
  end
  
  def klass(type)
    NAMES.fetch(type).fetch(:klass).to_s.singularize.camelcase
  end
  
end