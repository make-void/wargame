module View
  class ArmyUnit < ActiveRecord::Base
    set_table_name "wg_v_army_unit" 
    set_primary_keys "unit_id", "army_id"

    
    def consumption
      return self.cost * self.number
    end
    


    def readonly?
      true
    end
    
  end
end