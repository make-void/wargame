module DB # Database
  class UnitDefinition < ActiveRecord::Base
    set_table_name "wg_unit_defs" 
    set_primary_key "unit_id"
        
    validates_uniqueness_of :name
    validates_presence_of :power, :defence, :movement_speed, :cargo_capacity
    validates_numericality_of :power, :defence, :movement_speed, :movement_cost
    validates_numericality_of :cargo_capacity, :transport_capacity, :attack_type
    
    
    ATTACK_TYPES = {
      0 => "Normal",
      1 => "Vehicle Killer",
      2 => "Infantry Killer"
    }
        
  end
end