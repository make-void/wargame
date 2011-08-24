module LG # Logic
  class Location
       
    #Esample Usage
    #LG::Location.get_near( { type: "City" }, {latitude: 1.0102939, longitude: 49.198198, radius: 50} )
    def self.get_near( where_clause, position_hash )
      lat = position_hash[:latitude]
      lng = position_hash[:longitude]
      radius = position_hash[:radius]

      cities = View::CityLocation.where( where_clause ).near([lat, lng], radius)
      armies = View::ArmyLocation.where( where_clause ).near([lat, lng], radius)
      
      locs =  cities.map{|loc| parse_location(loc) }
      
      locs = locs + armies.map{|loc| parse_location(loc) }
        
      return locs.sort_by{|x| x[:location_id]}
    end
    
    
    protected
    
    def self.parse_location(loc)
      return {
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
              name: loc[:player_name]
            },
            alliance: {
              alliance_id: loc[:alliance_id],
              name: loc[:alliance_name]
            }
      }
      
    end
    
  end
end