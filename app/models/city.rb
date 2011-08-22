class City < ActiveRecord::Base
  
  belongs_to :location
  
end


# properties:
#
# id
# name
# location_id
