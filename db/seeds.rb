# execute rake db:seed
path = File.expand_path "../../", __FILE__

# step 1: recreate_tables
require "#{path}/db/recreate_tables"


########################################################
puts "\nseeding..."

cities = JSON.parse File.read("#{path}/db/cities.json")

cities.each do |city|
  city.symbolize_keys!
  loc = Location.create lat: city[:lat], lng: city[:lng]
  City.create name: city[:name], pts: 0, location_id: loc.id
end


puts "\ndone!"

