module LG # Logic
  class Location

    CITY_LIMIT = 30
       
    #Esample Usage
    #LG::Location.get_near( { type: "City" }, {latitude: 1.0102939, longitude: 49.198198, radius: 50} )
    def self.get_near( where_clause, position_hash )
      lat = position_hash[:latitude]
      lng = position_hash[:longitude]
      radius = position_hash[:radius]

      cities = View::CityLocation.where( where_clause ).near([lat, lng], radius).limit CITY_LIMIT
      armies = View::ArmyLocation.where( where_clause ).near([lat, lng], radius) ## We Can add in future HERE the rules for FOW
      
      locs =  cities.map{|loc| parse_location(loc) }
      
      locs = locs + armies.map{|loc| parse_location(loc) }
              
      return locs.sort_by{|x| x[:location_id]}
      
      
      # Sort by location_id. If city, first. then armies by army_id
    end
    
    
    protected
    
    def self.key_exists?(key)
      !key.nil? && key.to_i != 0
    end
    
    def self.parse_location(loc)
      location = {
        latitude: loc[:latitude].to_f,
        longitude: loc[:longitude].to_f,
        id: loc[:location_id].to_i,
        player: {
          id: loc[:player_id].to_i,
          name: loc[:player_name],
          alliance: {
            id: loc[:alliance_id].to_i,
            name: loc[:alliance_name]
          }
        }
      }
      
      city = {
        id: loc[:city_id].to_i,
        name: loc[:city_name],
        pts: loc[:city_pts].to_i,
        ccode: loc[:city_ccode]
      }
      
      army = {
        id: loc[:army_id].to_i
      }
      
      location[:city] = city if key_exists?(loc[:city_id])
      location[:army] = army if key_exists?(loc[:army_id])
      
      location
    end
    
  end
end