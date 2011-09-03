class DefinitionsController < ApplicationController
  
  NAMES = {
    # table => column
    structs: { klass: :structure }, 
    techs: { klass: :research, id_name: :tech }, #  FIXME: id_name is pathetic, rename all "structure_id" in "struct_id" pleaaaase! now! (also think about naming difference between tech,research and upgrades, with version control should be easy to rename)
    units: { klass: :unit },
  }
  
  layout nil
  
  def show
    @type = params[:type].to_sym
    filter_bad_intentions
    model = eval("DB::#{klass}::Definition")
    @resources = model.all
    render json: @resources
  end
  
  private
  
  def forbidden
    raise ActionController::RoutingError.new "Forbidden" # 403
  end
  
  def filter_bad_intentions
    forbidden unless NAMES.keys.include? @type
  end
  
  def klass
    NAMES.fetch(@type).fetch(:klass).to_s.singularize.camelcase
  end
  
end