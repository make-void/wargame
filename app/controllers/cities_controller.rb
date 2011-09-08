class CitiesController < ApplicationController
  
  layout nil
  
  def show
    data = LG::City.get params[:city]
    data = { error: { type: "not_found", message: "City not found (#{params[:city]})" } } unless data
    render json: data
  end
  
end