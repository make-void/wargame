module Modules
  module Queue
  
    def Queue.included(classe_di_arrivo)
      classe_di_arrivo.class_eval do
        extend ClassMethods
        include InstanceMethods
      end
    end
    
    
    module ClassMethods
    
    end
    
    module InstanceMethods
      def items=( db_entries_array )
        raise ArgumentError, "Need an array of DB::Queue::Unit. Got #{db_entries_array.map{|x| x.class}.uniq.inspect}" if db_entries_array != [] && db_entries_array.map{|x| x.class}.uniq != [self.class::DB_CLASS]
        @items = db_entries_array
      end
      
      def city_hash_money?(city_object, cost_hash)
        raise ArgumentError, "Need cost_hash to have a :gold key. Got #{cost_hash.inspect}" if cost_hash[:gold].nil?
        raise ArgumentError, "Need cost_hash to have a :steel key. Got #{cost_hash.inspect}" if cost_hash[:steel].nil?
        raise ArgumentError, "Need cost_hash to have a :oil key. Got #{cost_hash.inspect}" if cost_hash[:oil].nil?
        return city_object.has_resources?( cost_hash )
      end
      
      def check_requisites(city_object, object_definition)
        errors = building_requisites( [],     city_object, object_definition )
        errors = research_requisites( errors, city_object, object_definition )
  
        return true if errors.empty?
        return errors
      end
      
      
      def building_requisites(errors, city_object, object_definition )
        object_definition.building_reqs.each do |b_req|
          building = DB::Structure::Building.find(:first, :conditions => { 
                                                      :city_id => city_object.city_id,
                                                      :player_id => city_object.player_id,
                                                      :structure_id => b_req.req_structure_id
                                                    })
          if building.nil?
            errors.push(
              { 
                message: "Building '#{b_req.required_object.name}' is level 0. Need: #{b_req.level}", 
                city_id: city_object.city_id,
                structure_id: b_req.req_structure_id,
                level: 0,
                required_level: b_req.level
              }
            )
          end
          if !building.nil? && building.level < b_req.level
            errors.push(
              { 
                message: "Building '#{b_req.required_object.name}' is level #{building.level}. Need: #{b_req.level}", 
                city_id: city_object.city_id,
                structure_id: b_req.req_structure_id,
                level: building.level,
                required_level: b_req.level
              }
            )
          end
        end
        return errors
      end
      
      def research_requisites(errors, city_object, object_definition)
        object_definition.tech_reqs.each do |t_req|
          research = DB::Research::Upgrade.find(:first, :conditions => {
                                                      :tech_id => t_req.req_tech_id,
                                                      :player_id => city_object.player_id,
                                                    })
          
          if research.nil?
            errors.push(
              { 
                message: "Research '#{t_req.required_object.name}' is level 0. Need: #{t_req.level}", 
                city_id: city_object.city_id,
                structure_id: t_req.req_tech_id,
                level: 0,
                required_level: t_req.level
              }
            )
          end
          if !research.nil? && research.level < b_req.level
            errors.push(
              { 
                message: "Research '#{t_req.required_object.name}' is level #{research.level}. Need: #{t_req.level}", 
                city_id: city_object.city_id,
                structure_id: t_req.req_tech_id,
                level: t_req.level,
                required_level: t_req.level
              }
            )
          end
        end
        return errors
      end
      
    end
    
  end
end