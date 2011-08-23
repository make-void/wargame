class Location < ActiveRecord::Base
  set_table_name "wg_locations" 
  set_primary_key "location_id"
    
  validates_presence_of :latitude, :longitude
  validates_uniqueness_of :latitude, :scope => :longitude 
  
  has_many :cities 
  
  reverse_geocoded_by :latitude, :longitude # TODO: check if it doesn't add overhead
  
end

# properties:
#
# id
# lat
# lng