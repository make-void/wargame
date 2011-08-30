module DB # Database
  module Unit
    class Definition < ActiveRecord::Base
      set_table_name "wg_unit_defs" 
      set_primary_key "unit_id"
          
      validates_uniqueness_of :name
      validates_presence_of :power, :defence, :movement_speed, :cargo_capacity
      validates_numericality_of :power, :defence, :movement_speed, :movement_cost
      validates_numericality_of :cargo_capacity, :transport_capacity, :attack_type
      
      has_many :army_units, :foreign_key => :unit_id
      has_many :city_units, :foreign_key => :unit_id
      
      has_many :tech_reqs, :class_name => "DB::Unit::Requirement::Tech", :foreign_key => :unit_id
      has_many :building_reqs, :class_name => "DB::Unit::Requirement::Building", :foreign_key => :unit_id
      
      ATTACK_TYPES = {
        0 => "Normal",
        1 => "Vehicle Killer",
        2 => "Infantry Killer"
      }
          
    end
  end
end