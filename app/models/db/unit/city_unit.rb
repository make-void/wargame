module DB
  module Unit
    class CityUnit < ActiveRecord::Base
      set_table_name "wg_city_unit" 
      set_primary_keys "unit_id", "city_id"
      
      belongs_to :army
      belongs_to :player
    
      belongs_to :definition,
                 :foreign_key => :unit_id
    
      
      validates_presence_of :number, :player_id
      validates_numericality_of :number, :player_id
      
    end
  end
end