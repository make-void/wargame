module LG
  class Structures
    
    CostAdvancement = lambda{|cost, level , cost_advancement_type| cost * ((COST_ADVANCEMENT_RELATIONS[cost_advancement_type])**(level-1)) }
    ProductionByLevel = lambda{|base_production, level, server_speed| base_production * (level*(1.1**level)) * server_speed }
    
    COST_ADVANCEMENT_RELATIONS = {
      0 => 1.5,
      1 => 1.6,
      2 => 1.8,
      3 => 2
    }
    
    # =>  RETURNS: time in seconds
    def self.time( struct_definition_object, level, research_level, server_speed = 1 )
       raise ArgumentError, "Need DB::Structure::Definition Object. Got #{struct_definition_object.inspect}" unless struct_definition_object.class == DB::Structure::Definition
       structure_cost = Structures.cost( struct_definition_object, level )
       values = { gold: structure_cost[:gold], steel: structure_cost[:steel], research_level: research_level, server_speed: server_speed }
       return Helpers::TimeProcs::BuildingTime.call(values)
    end
    
    def self.cost( struct_definition_object, level, server_speed  = 1)
      raise ArgumentError, "Need DB::Structure::Definition Object. Got #{struct_definition_object.inspect}" unless struct_definition_object.class == DB::Structure::Definition
      c_a_t = struct_definition_object.cost_advancement_type
      values = {
                  gold: CostAdvancement.call(struct_definition_object.gold_cost, level, c_a_t).to_i, 
                  steel: CostAdvancement.call(struct_definition_object.steel_cost, level, c_a_t).to_i, 
                  oil: CostAdvancement.call(struct_definition_object.oil_cost, level, c_a_t).to_i
                }
      return values
    end
    
    def self.production( struct_definition_object, level, server_speed = 1)
      raise ArgumentError, "Need DB::Structure::Definition Object. Got #{struct_definition_object.inspect}" unless struct_definition_object.class == DB::Structure::Definition
      return nil if struct_definition_object.base_production.nil?
      return ProductionByLevel.call(struct_definition_object.base_production, level, server_speed).to_i
    end
    
    
  end
end