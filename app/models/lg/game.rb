module LG
  module Game
    
    def self.failcheck(player_id)
      raise "You are joking right? (u tried to fetch all npc infos, tsk!)" if player_id == 1
    end
    
    def self.get_base_infos_for_player( player_id )
      failcheck player_id 
      return { armies: fetch_armies_of_player(player_id), cities: fetch_cities_of_player(player_id), research: fetch_res_of_player(player_id) }
    end
    
    def self.armies(player_id)
      failcheck player_id
      fetch_armies_of_player player_id
    end
   
    def self.cities(player_id)
      failcheck player_id
      fetch_cities_of_player player_id
    end
   
    def self.get_all_base_infos()      
      return { units: fetch_units(), researches: fetch_researches(), structures: fetch_structures() }
    end
    
    #### GENERAL FETCH METHODS
    def self.fetch_researches
      researches_data = DB::Research::Definition.all
      
      researches = []
      researches_data.map do |res|
        
        research_requirements = []
        building_requirements = []
        
        res.tech_reqs.map do |t_req|
          research_requirements.push({ tech_id: t_req.req_tech_id, level: t_req.level })
        end
        res.building_reqs.map do |b_req|
          building_requirements.push({ structure_id: b_req.req_structure_id, level: b_req.level })
        end
        
        researches << {
          id: res.tech_id,
          name: res.name,
          description: res.description,
          cost: {
            gold: res.gold_cost,
            steel: res.steel_cost,
            oil: res.oil_cost,
            base_time: LG::Research.time( res, 1, 1 ).ceil
          },
          requirements: {
            researches: research_requirements,
            buildings: building_requirements
          },
          max_level: res.max_level
        }
        
      end
      
      return researches
    end
    
    def self.fetch_units
      units_data = DB::Unit::Definition.all
      
      units = []
      units_data.map do |unit|
        
        research_requirements = []
        building_requirements = []
        
        unit.tech_reqs.map do |t_req|
          research_requirements.push({ tech_id: t_req.req_tech_id, level: t_req.level })
        end
        unit.building_reqs.map do |b_req|
          building_requirements.push({ structure_id: b_req.req_structure_id, level: b_req.level })
        end
        
        units << {
          id: unit.unit_id,
          name: unit.name,
          unit_type: unit.unit_type,
          attack_type: DB::Unit::Definition::ATTACK_TYPES[unit.attack_type],
          cost: {
            gold: unit.gold_cost,
            steel: unit.steel_cost,
            oil: unit.oil_cost,
            base_time: LG::Unit.production_time( unit, 1 )
          },
          stats: {
            power: unit.power,
            defense: unit.defense,
            movement_speed: unit.movement_speed,
            movement_cost: unit.movement_cost,
            cargo_capacity: unit.cargo_capacity,
            transport_capacity: unit.transport_capacity
          },
          requirements: {
            researches: research_requirements,
            buildings: building_requirements
          }
        }
        
      end
      return units
    end
    
    def self.fetch_structures
      structures_data = DB::Structure::Definition.all
      
      structures = []
      structures_data.map do |struct|
        
        research_requirements = []
        building_requirements = []
        
        struct.tech_reqs.map do |t_req|
          research_requirements.push({ tech_id: t_req.req_tech_id, level: t_req.level })
        end
        struct.building_reqs.map do |b_req|
          building_requirements.push({ structure_id: b_req.req_structure_id, level: b_req.level })
        end
        
        structure = {
          id: struct.structure_id,
          name: struct.name,
          description: struct.description,
          cost: {
            gold: struct.gold_cost,
            steel: struct.steel_cost,
            oil: struct.oil_cost,
            base_time: LG::Structures.time( struct, 1, 1 ).ceil
          },
          requirements: {
            researches: research_requirements,
            buildings: building_requirements
          },
          max_level: struct.max_level
        }
        structure[:base_production] = struct.base_production unless struct.base_production.nil?
        
        structures << structure
      end
      
      return structures
    end
    
    #### LOCALIZED ON USER FETCH METHODS
    def self.fetch_armies_of_player( player_id )
      armies = {}
      DB::Army.where( player_id: player_id ).map do |a|
        loc = a.location
        {
           id: a.army_id,
           type: "army",
           location: { 
               latitude: loc.latitude.to_f, 
               longitude: loc.longitude.to_f, 
               location_id: loc.location_id 
             },
            is_moving: a.is_moving
        }
      end
      
      return armies
    end

    def self.fetch_cities_of_player( player_id )
      cities = {}
      DB::City.find(:all, conditions: {player_id: player_id}).map do |c|
        loc = c.location
        {
          id: c.city_id,
          type: "city",
          name: c.name,
          ccode: c.ccode,
          location: { 
            latitude: loc.latitude.to_f, 
            longitude: loc.longitude.to_f, 
            location_id: loc.location_id 
          }
        }
      end
    end
    
    def self.fetch_res_of_player( player_id )
      research = {}
      DB::Research::Upgrade.find(:all, conditions: {player_id: player_id}).map do |r|
        research = {
          id: r.tech_id,
          level: r.level,
          upgade_cost: {
            gold: r.next_lev_gold_cost,
            steel: r.next_lev_steel_cost,
            oil: r.next_lev_oil_cost
          }
        }
      end
    end
    
###################################
#     BUILDING COMPLETE PUTS      #
###################################
    
    def self.get_all_building_infos
      b_infos = fetch_structures()
      
      b_infos.each do |x,y|
        puts "#{x}: #{y[:name]}"
        puts "    - #{y[:description]}"
        puts "    - Requirements: (Researches)"
        y[:requirements][:researches].map do |res_req|
          puts "        - #{DB::Research::Definition.find(res_req[:tech_id]).name}: #{res_req[:level]}"
        end
        puts "    - Requirements: (Buildings)"
        y[:requirements][:buildings].map do |build_req|
          puts "        - #{DB::Structure::Definition.find(build_req[:structure_id]).name}: #{build_req[:level]}"
        end
        
        puts "    - Cost Per Level:"
        level = 0
        this_object =  DB::Structure::Definition.find(x)
        while level < y[:max_level]
          cost = LG::Structures.cost( this_object, level + 1 )
          time = LG::Structures.time( this_object, level + 1, 1 )
          puts "\t Level #{level + 1}: gold #{cost[:gold]}, steel #{cost[:steel]}, oil #{cost[:oil]}, time (seconds) #{time.floor}"
          level += 1
        end
        if ["Warehouse", "Bank"].include?(this_object.name)
          puts "    - Storage Per Level:"
          level = 0
          while level < y[:max_level]
            puts "\t Level #{level + 1}: #{LG::Structures.storage( this_object, level + 1)}"
            level += 1
          end
        end

        level = 0
        unless y[:base_production].nil?
          puts "    - Production Per Level:"
          while level < y[:max_level]
            production = LG::Structures.production( this_object, level + 1 )
            puts "\t Level #{level + 1}: #{production}/h"
            level += 1
          end
        end
      end
      return nil
    end
    
    
    extend GameDebug

 end
end