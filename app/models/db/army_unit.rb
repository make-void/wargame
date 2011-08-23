module DB
  class ArmyUnit < ActiveRecord::Base
    set_table_name "wg_army_unit" 
    set_primary_keys "unit_id", "army_id"
    
    belongs_to :army
    belongs_to :unit
    belongs_to :player
    
    validates_presence_of :number, :player_id
    validates_numericality_of :number, :player_id
    
  end
end