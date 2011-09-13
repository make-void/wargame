module LG
  module City
    
    def self.get(name)
      city = DB::City.find(:first, conditions: { name: name }, include: :location)
      city.attributes.merge( location: city.location.attributes ) unless city.nil?
    end
    
    
    def self.all( player )
      # player.cities.map do |city| # with counter cache
      player.cities.find(:all, include: :units).map do |city| # without it
        city_attributes(city).merge( 
          stats: stats_attributes(city),
          location: location_attributes(city),
        )
      end
    end
    
    #Example Call: 
    #     LG::City.get_city_infos( DB::City.last.city_id, 2 ) #Not My City
    #     LG::City.get_city_infos( DB::City.last.city_id, 1 ) #My City
    def self.get_city_infos( city_id, player_id )
      
      errors = []
      begin
        city = DB::City.find( city_id )
      rescue ActiveRecord::RecordNotFound
        errors.push "City Does Not Exist"
      end
      begin
        player = DB::Player.find( player_id )
      rescue ActiveRecord::RecordNotFound
        errors.push "Player Does Not Exist"
      end
      return { errors: errors } if errors.size != 0
      
      infos = if city.player_id == player.player_id
        #It's My Damn City... Show all Data
        city_queue = LG::Queue::CityQueue.get( city_id, player_id )
        
        return { errors: errors } if city_queue.errors.size != 0
        
        buildings = city.buildings.map do |b|
          { 
            id: b.structure_id,
            level: b.level,
            upgade_cost: {
              gold: b.next_lev_gold_cost,
              steel: b.next_lev_steel_cost,
              oil: b.next_lev_oil_cost
            }
          }
        end
        
        city_attributes(city).merge(
          player: player_attributes(player),
          queues: city_queue.get, 
          buildings: buildings,
          stats: stats_attributes(city),
          units: units_attributes(city),
          errors: errors,
        )    
      else #It's not My City! HIDE Data
        enemy_player = city.player        
        {
          name: city.name,
          ccode: city.ccode,
          player: player_attributes(enemy_player),
          stats: stats_attributes(city),
          errors: errors,
        }
      end
      
      infos.merge! location: location_attributes(city)
                  
      infos      
    end
    
    def self.location_attributes(city)
      loc = city.location
      { 
        latitude: loc.latitude.to_f, 
        longitude: loc.longitude.to_f, 
        id: loc.location_id 
      }
    end
    
    def self.stats_attributes(city)
      {
        power: city.overall_power,
        defence: city.overall_defense,
      }
    end
    
    def self.units_attributes(city)
      city.units.map do |u|
        { id: u.unit_id, number: u.number}
      end
    end
    
    def self.player_attributes(player)
      ally = player.alliance
      {
        name: player.name,
        player_id: player.player_id,
        ally: {
          name: ally.name,
          alliance_id: ally.alliance_id,
        },
      }
    end
    
    def self.city_attributes(city)
      {
        id: city.city_id,
        name: city.name,
        ccode: city.ccode,
        production: {
          gold: city.gold_production,
          steel: city.steel_production,
          oil: city.oil_production
        },
        storage_space: {
          gold: city.gold_storage_space,
          steel: city.steel_storage_space,
          oil: city.oil_storage_space
        },
        stored: {
          gold: city.gold_stored,
          steel: city.steel_stored,
          oil: city.oil_stored
        },
      }
    end
    
  end
end