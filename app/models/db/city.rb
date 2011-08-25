module DB # Database
  class City < ActiveRecord::Base
    set_table_name "wg_cities" 
    set_primary_key "city_id"
    
    validates_presence_of :name
    
    belongs_to :location
    belongs_to :player
    
    has_many :units, :class_name => "DB::Unit::CityUnit"
    
    
  end
end

# properties:
#
# id
# name
# location_id
