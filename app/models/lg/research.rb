module LG
  class Research
   
   
    def self.cost( res_definition_object, level )
      raise ArgumentError, "Need DB::Research::Definition Object. Got #{res_definition_object.inspect}" unless res_definition_object.class == DB::Research::Definition
      return {gold: res_definition_object.gold_cost * (level), steel: res_definition_object.steel_cost * (level), oil: res_definition_object.oil_cost * (level) }
    end
    # =>  RETURNS: time in seconds
    def self.time( res_definition_object, level, res_centre, server_speed = 1 )
      raise ArgumentError, "Need DB::Research::Definition Object. Got #{res_definition_object.inspect}" unless res_definition_object.class == DB::Research::Definition
      values = { gold: res_definition_object.gold_cost * (level), steel: res_definition_object.steel_cost * (level), level: level, research_level: research_level, server_speed: server_speed}       
      return Helpers::TimeProcs::ResearchTime.call(values)
    end
    
  end
end