class CitiesController < ApplicationController
  
  layout nil
  
  def show 
    # Why not use the other method in LG::City witch return mutch more infos?
    # because i saw this first :p anyway you can also change it
    data = LG::City.get params[:city]
    data = { error: { type: "not_found", message: "City not found (#{params[:city]})" } } unless data
    render json: data
  end
  
end