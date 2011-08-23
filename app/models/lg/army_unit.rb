module LG
  class ArmyUnit < ActiveRecord::Base
    set_table_name "wg_army_unit_view" 
    set_primary_keys "unit_id", "army_id"

    
    
    def readonly!
      @readonly = true
    end

    def readonly?
      defined?(@readonly) && @readonly == true
    end
    
  end
end