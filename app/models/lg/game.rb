module LG
  module Game
    
    def self.get_base_infos_for_player( player_id )
      
    end
   
    def self.get_all_base_infos()      
      return { :units => fetch_units(), :researches => fetch_researches(), :structures => fetch_structures() }
    end
    
    def self.fetch_researches
      researches_data = DB::Research::Definition.all
      
      researches = {}
      researches_data.map do |res|
        
        research_requirements = []
        building_requirements = []
        
        res.tech_reqs.map do |t_req|
          research_requirements.push({ :tech_id => t_req.req_tech_id, :level => t_req.level })
        end
        res.building_reqs.map do |b_req|
          building_requirements.push({ :structure_id => b_req.req_structure_id, :level => b_req.level })
        end
        
        researches[res.tech_id] = {
          :name => res.name,
          :description => res.description,
          :cost => {
            :gold => res.gold_cost,
            :steel => res.steel_cost,
            :oil => res.oil_cost,
            :base_time => LG::Research.time( res, 1, 1 ).ceil
          },
          :requirements => {
            :researches => research_requirements,
            :buildings => building_requirements
          },
          :max_level => res.max_level
        }
        
      end
      
      return researches
    end
    
    def self.fetch_units
      units_data = DB::Unit::Definition.all
      
      units = {}
      units_data.map do |unit|
        
        research_requirements = []
        building_requirements = []
        
        unit.tech_reqs.map do |t_req|
          research_requirements.push({ :tech_id => t_req.req_tech_id, :level => t_req.level })
        end
        unit.building_reqs.map do |b_req|
          building_requirements.push({ :structure_id => b_req.req_structure_id, :level => b_req.level })
        end
        
        units[unit.unit_id] = {
          :name => unit.name,
          :unit_type => unit.unit_type,
          :attack_type => DB::Unit::Definition::ATTACK_TYPES[unit.attack_type],
          :cost => {
            :gold => unit.gold_cost,
            :steel => unit.steel_cost,
            :oil => unit.oil_cost,
            :base_time => LG::Unit.production_time( unit, 1 )
          },
          :stats => {
            :power => unit.power,
            :defense => unit.defense,
            :movement_speed => unit.movement_speed,
            :movement_cost => unit.movement_cost,
            :cargo_capacity => unit.cargo_capacity,
            :transport_capacity => unit.transport_capacity
          },
          :requirements => {
            :researches => research_requirements,
            :buildings => building_requirements
          }
        }
        
      end
      return units
    end
    
    def self.fetch_structures
      structures_data = DB::Structure::Definition.all
      
      structures = {}
      structures_data.map do |struct|
        
        research_requirements = []
        building_requirements = []
        
        struct.tech_reqs.map do |t_req|
          research_requirements.push({ :tech_id => t_req.req_tech_id, :level => t_req.level })
        end
        struct.building_reqs.map do |b_req|
          building_requirements.push({ :structure_id => b_req.req_structure_id, :level => b_req.level })
        end
        
        structures[struct.structure_id] = {
          :name => struct.name,
          :description => struct.description,
          :cost => {
            :gold => struct.gold_cost,
            :steel => struct.steel_cost,
            :oil => struct.oil_cost,
            :base_time => LG::Structures.time( struct, 1, 1 ).ceil
          },
          :requirements => {
            :researches => research_requirements,
            :buildings => building_requirements
          },
          :max_level => struct.max_level
        }
        structures[struct.structure_id][:base_production] = struct.base_production unless struct.base_production.nil?
      end
      
      return structures
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

###################################
#      BUILDING DEBUG PUTS        #
###################################

  def self.debug_buildings
    LG::Game.get_all_base_infos()[:structures].each do |x,y|
      puts "#{x}: #{y[:name]}"
      puts "    - #{y[:description]}"
      puts "    - Cost: gold #{y[:cost][:gold]}, steel #{y[:cost][:steel]}, oil #{y[:cost][:oil]}, time(seconds) #{y[:cost][:base_time]}"
      puts "    - Max Level: #{y[:max_level]}"
      puts "    - Requirements: (Researches)"
      y[:requirements][:researches].map do |res_req|
        puts "        - #{DB::Research::Definition.find(res_req[:tech_id]).name}: #{res_req[:level]}"
      end
      puts "    - Requirements: (Buildings)"
      y[:requirements][:buildings].map do |build_req|
        puts "        - #{DB::Structure::Definition.find(build_req[:structure_id]).name}: #{build_req[:level]}"
      end
      puts "    - BASE PRODUCTION: #{y[:base_production]}" if y[:base_production]

    end
    return nil
  end

###################################
#         UNITS DEBUG PUTS        #
###################################

    def self.debug_units
      LG::Game.get_all_base_infos()[:units].each do |x,y|
        puts "#{x}: #{y[:name]} (#{y[:stats][:power]}/#{y[:stats][:defense]})"
        puts "    - AttackType: #{y[:attack_type]}"
        puts "    - Movement: Speed #{y[:stats][:movement_speed]}, Cost #{y[:stats][:movement_cost]}"
        puts "    - Transport: Units #{y[:stats][:transport_capacity]}, Resources #{y[:stats][:cargo_capacity]}"
        puts "    - Cost: gold #{y[:cost][:gold]}, steel #{y[:cost][:steel]}, oil #{y[:cost][:oil]}, time(seconds) #{y[:cost][:base_time]}"
        puts "    - Requirements: (Research)"
        y[:requirements][:researches].map do |res_req|
          puts "        - #{DB::Research::Definition.find(res_req[:tech_id]).name}: #{res_req[:level]}"
        end
        puts "    - Requirements: (Buildings)"
        y[:requirements][:buildings].map do |build_req|
          puts "        - #{DB::Structure::Definition.find(build_req[:structure_id]).name}: #{build_req[:level]}"
        end
      end
      return nil
    end

###################################
#      RESEARCHES DEBUG PUTS      #
###################################

  def self.debug_researches
    LG::Game.get_all_base_infos()[:researches].each do |x,y|
      puts "#{x}: #{y[:name]}"
      puts "    - #{y[:description]}"
      puts "    - Cost: gold #{y[:cost][:gold]}, steel #{y[:cost][:steel]}, oil #{y[:cost][:oil]}, time(seconds) #{y[:cost][:base_time]}"
      puts "    - Max Level: #{y[:max_level]}"
      puts "    - Requirements: (Researches)"
      y[:requirements][:researches].map do |res_req|
        puts "        - #{DB::Research::Definition.find(res_req[:tech_id]).name}: #{res_req[:level]}"
      end
      puts "    - Requirements: (Buildings)"
      y[:requirements][:buildings].map do |build_req|
        puts "        - #{DB::Structure::Definition.find(build_req[:structure_id]).name}: #{build_req[:level]}"
      end
      
    end
    return nil
  end

 end
end