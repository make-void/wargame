# encoding: utf-8
PATH = File.expand_path "../../", __FILE__


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


# batching FAIL
#
# def import(lines)
#   cities = []
#   locations = []
#   lines.each do |line|
#     # ad,aixas,Aix‡s,06,,42.4833333,1.4666667
#     split = line.split(",")
#     name, lat, lng = split[2], split[5], split[6]
#     loc = Location.new lat: lat, lng: lng 
#     city = City.new name: name, location_id: loc
#     cities << city
#     locations << loc
#   end
#   locs = Location.import locations
#   raise locs.inspect
# end
# 
# def batching(batch, lines, num)
#   if batch * num <= 10
#     lines << line
#   else
#     import lines
#     lines = []
#   end
# end

def import(line)
  # ad,aixas,Aix‡s,06,,42.4833333,1.4666667
  split = line.split(",")
  ccode, name, lat, lng = split[0], split[2], split[5], split[6]

  begin
    loc = Location.create latitude: lat.to_f, longitude: lng.to_f 
    loc = Location.find(:first, :conditions => {latitude: lat.to_f, longitude: lng.to_f}) if loc.id.nil? #AR VALIDATION
  rescue ActiveRecord::RecordNotUnique #DB VALIDATION
    loc = Location.find(:first, :conditions => {latitude: lat.to_f, longitude: lng.to_f})
    raise "Error... No Location for #{lat.to_f} - #{lng.to_f}" if loc.nil?
  end
  
  City.create name: name, ccode: ccode, location_id: loc.id, player_id: 1
end

# http://products.wolframalpha.com/api/explorer.html - 20k cities per account per month
# population firenze, reggello, siena, roma, viterbo, terni, napoli, milano, campagnano di roma, lizzano

def create_default_alliance_and_player
  Alliance.create name: "No Alliance"
  Player.create name: "Free Lands", new_password: "NULLABLE", new_password_confirmation: "NULLABLE", email: "test@test.test", alliance_id: 1
end

def step_2
  require "#{PATH}/config/environment"
  require "#{PATH}/db/recreate_tables"
  
  create_default_alliance_and_player
  # batch = 10
  # lines = []
  num = 0
  File.open("#{PATH}/db/europe_cities.txt").each_line do |line|
    num += 1
    #batching(batch, lines, num)
    next unless num % 100 == 0
    import line
#    break if num == 50
  end

  
end

# step_1
step_2

