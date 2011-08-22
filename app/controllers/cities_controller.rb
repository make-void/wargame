class CitiesController < ApplicationController
  
  # TODO: move in a separate rack app for speed
  
  def index
    lat, lng = [43.7687324, 11.2569013]
    radius = 100
    
    

    type = {}
    # TODO: uncomment when implementing location type (City, Army...)
    # type = { type: "City" }
    locs = Location.where(type).near([lat, lng], radius)
    # location: {"bearing":"16.0","distance":0.00011124609308931382,"id":1,"lat":43.7687,"lng":11.2569}
    render text: { markers: locs }.to_json
  end
  
end