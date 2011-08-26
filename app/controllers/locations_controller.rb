class LocationsController < ApplicationController
  
  # TODO: move in a separate rack app for speed

  def index
    lat, lng = [params[:lat].to_f, params[:lng].to_f]
    radius = 50
    
    type = {}
    # TODO: uncomment when implementing location type (City, Army...)
    # type = { type: "City" }
    locs =  LG::Location.get_near( type, {latitude: lat, longitude: lng, radius: radius} )
    
    render text: { locations: locs }.to_json
  end
  
end