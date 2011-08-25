module Helpers
  module TimeProcs
    
    # =>  values = { gold: int, steel: int, level: int, res_centre: int, server_speed: 1}
    # =>  RETURNS: time in seconds
    ResearchTime = lambda{|values| ( ( values[:gold] + values[:steel] ) / ( values[:server_speed] * 1000 * (1 + values[:res_centre]) ).to_f ) * 3600 }
    
    # =>  values = { gold: int, steel: int, level: int, research_level: int, server_speed: 1}
    BuildingTime = lambda{|values| ( ( values[:gold] + values[:steel] ) / ( values[:server_speed] * 2500 * (1 + values[:research_level]) ).to_f )  * 3600}
    
    
  end
end