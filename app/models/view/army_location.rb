module View
  class ArmyLocation < ActiveRecord::Base
    set_table_name "wg_v_army_locations"
    
    reverse_geocoded_by :latitude, :longitude # TODO: check if it doesn't add overhead
    
    
    
    def readonly?
      true
    end
    
  end
end