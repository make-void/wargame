# encoding: utf-8
PATH = File.expand_path "../../", __FILE__

env = ARGV[0]
ENV["RACK_ENV"] = env if env


require 'json'

# { "code": "RU",	"name": "Russian Federation"                          },
# { "code": "IS",	"name": "Iceland"                                     },
# { "code": "IE",	"name": "Ireland"                                     },
# { "code": "UK",	"name": "United Kingdom"                              },
# { "code": "NO", "name": "Norway"                                      },
# { "code": "SE", "name": "Sweden"                                      },
# { "code": "FI", "name": "Finland"                                     },
# { "code": "TR",	"name": "Turkey"                                      },

ccodes = JSON.parse File.read("#{PATH}/db/country_codes.json")
ccodes = ccodes.map{|c| c["code"]}.map{ |c| c.downcase }

def step_1
  require 'fileutils'
  FileUtils.rm "#{PATH}/db/europe_cities.txt"
  file = File.open("#{PATH}/db/europe_cities.txt", "a:UTF-8")

  File.open("#{PATH}/db/worldcitiespop.txt", "r:UTF-8").each_line do |line|
    file.write line if ccodes.include? line.split(/,/)[0]
  end
  puts `wc -l europe_cities.txt`
end

def import(city)
  # ad,aixas,Aix‡s,06,,42.4833333,1.4666667
  ccode, name, pop, lat, lng = city.split(",")
  # begin
    loc = DB::Location.create latitude: lat.to_f, longitude: lng.to_f 
    
    # SORRY, no time for this, prefilter out taking the most populated location
    
    #   loc = DB::Location.find(:first, :conditions => {latitude: city["lat"].to_f, longitude: city["lng"].to_f}) if loc.id.nil? #AR VALIDATION
    # rescue ActiveRecord::RecordNotUnique #DB VALIDATION
    #   loc = DB::Location.find(:first, :conditions => {latitude: city["lat"].to_f, longitude: city["lng"].to_f})
    #   raise "Error... No Location for #{city["lat"].to_f} - #{city["lng"].to_f}" if loc.nil?
    # end
  
  if loc.id.nil?
    # puts "not inserted: #{name}" 
  else
    DB::City.create name: name, ccode: ccode, location_id: loc.id, player_id: 1, pts: pop
  end
end

# http://products.wolframalpha.com/api/explorer.html - 20k cities per account per month
# population firenze, reggello, siena, roma, viterbo, terni, napoli, milano, campagnano di roma, lizzano

require "#{PATH}/db/default_values"
include DefaultValues
`cd #{PATH}/db; rm -f cities_pop.json; unzip #{PATH}/db/cities_pop.json.zip`

require "#{PATH}/lib/tasks_utils"

# slow method (from file)
def import_cities_from_file
  cities = JSON.parse File.read("#{PATH}/db/cities_pop.json")
  cities.each do |city|
    import city
  end
end

# fast method (from dump)
def import_cities_from_dump
  unzip_and_import "cities"
  unzip_and_import "locations"
end

def step_2
  require "#{PATH}/config/environment"  
  require "#{PATH}/db/recreate_tables"

  unless Rails.env == "test"
    create_default_vals
  
    # import_cities_from_file
    import_cities_from_dump
  
  
    create_default_vals_after_location
  end

end

# step_1
step_2 

