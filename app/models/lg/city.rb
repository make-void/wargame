module LG
  module City
    
    #Example Call: 
    #     LG::City.get_city_infos( DB::City.last.city_id, 2 ) #Not My City
    #     LG::City.get_city_infos( DB::City.last.city_id, 1 ) #My City
    def self.get_city_infos( city_id, logged_user_id )
      
      errors = []
      begin
        city_entry = DB::City.find( city_id )
      rescue ActiveRecord::RecordNotFound
        errors.push "City Does Not Exist"
      end
      begin
        player_entry = DB::Player.find( logged_user_id )
      rescue ActiveRecord::RecordNotFound
        errors.push "Player Does Not Exist"
      end
      return { :errors => errors } if errors.size != 0
      
      if city_entry.player_id == logged_user_id
        v = {
          :name => city_entry.name,
          :ccode => city_entry.ccode,
          :gold_production => city_entry.gold_production,
          :gold_stored => city_entry.gold_stored,
          :gold_storage_spage => city_entry.gold_storage_space,
          :steel_production => city_entry.steel_production,
          :steel_stored => city_entry.steel_stored,
          :steel_storage_spage => city_entry.steel_storage_space,
          :oil_production => city_entry.oil_production,
          :oil_stored => city_entry.oil_stored,
          :oil_storage_spage => city_entry.oil_storage_space,
          :queues => { 
            :unit => "To Be Implemented",
            :research => "To Be Implemented",
            :building => "To Be Implemented"
          },
          :errors => errors
        }
      else
        enemy_player = city_entry.player
        ally = enemy_player.alliance
        
        v = {
          :name => city_entry.name,
          :ccode => city_entry.ccode,
          :player_name => enemy_player.name,
          :player_id => enemy_player.player_id,
          :ally_name => ally.name,
          :ally_id => ally.alliance_id,
          :errors => errors
        }
      end
      
      loc = city_entry.location
      v.merge!( :latitude => loc.latitude.to_f, :longitude => loc.longitude.to_f, :location_id => loc.location_id )
                  
      return v 
      
    end
    
  end
end