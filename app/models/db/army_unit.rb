module DB
  class ArmyUnit < ActiveRecord::Base
    set_table_name "wg_army_unit" 
    set_primary_keys "unit_id", "army_id"
    
    belongs_to :army
    belongs_to :player

    belongs_to :unit_definition,
               :foreign_key => :unit_id

    
    validates_presence_of :number, :player_id
    validates_numericality_of :number, :player_id
    
  end
end