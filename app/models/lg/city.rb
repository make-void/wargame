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
      
      if city_entry.player_id == player_entry.player_id
        #It's My Damn City... Show all Data
        ally = player_entry.alliance
        
        city_queue = LG::Queue::CityQueue.get( city_id, logged_user_id )
        
        return {:errors => errors } if city_queue.errors.size != 0
        
        building_hash = {}
        city_entry.buildings.map do |b|
          building_hash[b.structure_id] = { 
            :level => b.level,
            :upgade_cost => {
              :gold => b.next_lev_gold_cost,
              :steel => b.next_lev_steel_cost,
              :oil => b.next_lev_oil_cost
            }
          }
        end
        unit_hash = {}
        city_entry.units.map do |u|
          unit_hash[b.unit_id] = {:number => u.number}
        end
        
        v = {
          :name => city_entry.name,
          :ccode => city_entry.ccode,
          :player => {
            :name => player_entry.name,
            :player_id => player_entry.player_id
          },
          :ally => {
            :name => ally.name,
            :alliance_id => ally.alliance_id
          },
          :production => {
            :gold => city_entry.gold_production,
            :steel => city_entry.steel_production,
            :oil => city_entry.oil_production
          },
          :storage_space => {
            :gold => city_entry.gold_storage_space,
            :steel => city_entry.steel_storage_space,
            :oil => city_entry.oil_storage_space
          },
          :stored => {
            :gold => city_entry.gold_stored,
            :steel => city_entry.steel_stored,
            :oil => city_entry.oil_stored
          },
          :buildings => building_hash,
          :units => {
            :overall_power => city_entry.overall_power,
            :overall_defence => city_entry.overall_defense,
            :units => unit_hash
          },
          :queues => city_queue.get,
          :errors => errors
        }
        
        #TODO -> Add infos about Buildings & Soldiers
        
      else #It's not My City! HIDE Data
        enemy_player = city_entry.player
        ally = enemy_player.alliance
        
        v = {
          :name => city_entry.name,
          :ccode => city_entry.ccode,
          :player => {
            :name => enemy_player.name,
            :player_id => enemy_player.player_id
          },
          :ally => {
            :name => ally.name,
            :alliance_id => ally.alliance_id
          },
          :battle_data => {
            :overall_power => city_entry.overall_power,
            :overall_defence => city_entry.overall_defense
          },
          :errors => errors
        }
      end
      
      loc = city_entry.location
      v.merge!( {
        :location => { 
          :latitude => loc.latitude.to_f, 
          :longitude => loc.longitude.to_f, 
          :location_id => loc.location_id 
        }
      })
                  
      return v 
      
    end
    
  end
end