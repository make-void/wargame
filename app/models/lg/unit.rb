module LG
  module Unit
    # =>  RETURNS: time in seconds
    def self.production_time( unit_object, building_level, server_speed = 1 )
      raise ArgumentError, "Need UnitObject. Got #{unit_object.inspect}" unless unit_object.is_a?(DB::Unit::Definition)
      values = { gold: unit_object.gold_cost, steel: unit_object.steel_cost,  building_level: building_level, server_speed: server_speed}       
      return Helpers::TimeProcs::UnitProductionTime.call(values).to_i
    end
     
  end
end