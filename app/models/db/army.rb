module DB # Database
  class Army < ActiveRecord::Base
    set_table_name "wg_armies" 
    set_primary_key "army_id"
        
    belongs_to :location
    belongs_to :player  
    
    has_many :army_units
    
    def is_moving?
      return is_moving == 1
    end
    
  end
end

# properties:
#
# id
# location_id
# ...