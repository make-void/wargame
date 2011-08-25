module DB
  module Unit
    class CityUnit < ActiveRecord::Base
      set_table_name "wg_city_unit" 
      set_primary_keys "unit_id", "city_id"
      
      belongs_to :army, :class_name => "DB::Army"
      belongs_to :player, :class_name => "DB::Player"
    
      belongs_to :definition, :foreign_key => :unit_id
    
      
      validates_presence_of :number, :player_id
      validates_numericality_of :number, :player_id
      
    end
  end
end