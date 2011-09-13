class LocationsController < ActionController::Base
  
  # TODO: move in a separate rack app for speed
  include ActionController::Rendering

  layout nil

  def index
    lat, lng = [params[:lat].to_f, params[:lng].to_f]
    radius = 50
    
    where = {} # TODO: filter by player (or by type or whatever)
    locs =  LG::Location.get_near( where, { latitude: lat, longitude: lng, radius: radius } )
    
    render json: { locations: locs }
  end
  
end