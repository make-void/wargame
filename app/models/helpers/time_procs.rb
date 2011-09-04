module Helpers
  module TimeProcs
    
    # =>  values = { gold: int, steel: int, level: int, res_center: int, server_speed: 1}
    # =>  RETURNS: time in seconds
    ResearchTime = lambda{|values| ( ( values[:gold] + values[:steel] ) / ( values[:server_speed] * 1000 * (1 + values[:research_level]) ).to_f ) * 3600 }
    
    # =>  values = { gold: int, steel: int, level: int, research_level: int, server_speed: 1}
    BuildingTime = lambda{|values| ( ( values[:gold] + values[:steel] ) / ( values[:server_speed] * 2500 * (1 + values[:research_level]) ).to_f )  * 3600}
    
    # => values = { gold: int, steel: int, building_level: int, server_speed: 1 }
    UnitProductionTime = lambda{|values| ( ( values[:gold] + values[:steel] ) / ( 2500 * ( 1 + values[:building_level] ) * values[:server_speed] ).to_f ) * 3600 }
    
  end
end