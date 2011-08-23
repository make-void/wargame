module Logic
  class Location
       
    #Esample Usage
    #Logic::Location.get_near( { type: "City" }, {latitude: 1.0102939, longitude: 49.198198, radius: 50} )
    def self.get_near( where_clause, position_hash )
      lat = position_hash[:latitude]
      lng = position_hash[:longitude]
      radius = position_hash[:radius]
      return Database::Location.includes(:city).where( where_clause ).near([lat, lng], radius)
    end
    
  end
end