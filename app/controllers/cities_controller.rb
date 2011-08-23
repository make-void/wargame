class CitiesController < ApplicationController
  
  # TODO: move in a separate rack app for speed

  # http://localhost:3000/cities/43.7687324/11.2569013
  def index
    #lat, lng = [43.7687324, 11.2569013]
    lat, lng = [params[:lat].to_f, params[:lng].to_f]
    radius = 50
    
    type = {}
    # TODO: uncomment when implementing location type (City, Army...)
    # type = { type: "City" }
    locs = LG::Location.get_near( type, {latitude: lat, longitude: lng, radius: radius} ).map do |loc| 
      
      # TODO: continue here!!!
      city = loc.city.try(:attributes)
      loc.attributes.merge(city: city) 
    end
    # location: {"bearing":"16.0","distance":0.00011124609308931382,"id":1,"lat":43.7687,"lng":11.2569}
    render text: { markers: locs }.to_json
  end
  
end