class Location < ActiveRecord::Base

  has_many :cities
  
  reverse_geocoded_by :lat, :lng # TODO: check if it doesn't add overhead
  
end

# properties:
#
# id
# lat
# lng