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
    locs =  LG::Location.get_near( type, {latitude: lat, longitude: lng, radius: radius} ).map do |loc|
      
      new_loc = {
            latitude: loc[:latitude],
            longitude: loc[:longitude],
            location_id: loc[:location_id],
            city: {
              city_id: loc[:city_id],
              name: loc[:city_name],
              pts: loc[:city_pts],
              ccode: loc[:city_ccode]
            },
            army: {
              army_id: loc[:army_id]
            },
            player: {
              player_id: loc[:player_id],
              name: loc[:player_name],
              alliance_id: loc[:alliance_id]
            }
      }
      
    end
    
    # location: {"bearing":"16.0","distance":0.00011124609308931382,"id":1,"lat":43.7687,"lng":11.2569}
    render text: { markers: locs }.to_json
  end
  
end