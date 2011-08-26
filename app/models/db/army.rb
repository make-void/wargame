module DB # Database
  class Army < ActiveRecord::Base
    set_table_name "wg_armies" 
    set_primary_key "army_id"
        
    belongs_to :location
    belongs_to :player  
    
    has_many :units, :class_name => "DB::Unit::ArmyUnit"
    
    def destination
      return nil unless self.is_moving?
      return Location.find(self.destination_id)
    end
    
    def is_moving?
      return self.is_moving
    end

  end
end