module LG
  module Game
   
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
            :base_time => LG::Research.time( res, 1, 1 )
          },
          :requirements => {
            :researches => research_requirements,
            :buildings => building_requirements
          }
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
            :defence => unit.defence,
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
            :base_time => LG::Structures.time( struct, 1, 1 )
          },
          :requirements => {
            :researches => research_requirements,
            :buildings => building_requirements
          }
        }
        
        structures[struct.structure_id][:base_production] = struct.base_production unless struct.base_production.nil?
      end
      
      return structures
    end
    
    
  end
end