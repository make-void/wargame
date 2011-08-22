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
  loc.cities.create name: city[:name], pts: 0
end


puts "\ndone!"

