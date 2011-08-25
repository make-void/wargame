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
    loc = DB::Location.create latitude: lat.to_f, longitude: lng.to_f 
    loc = DB::Location.find(:first, :conditions => {latitude: lat.to_f, longitude: lng.to_f}) if loc.id.nil? #AR VALIDATION
  rescue ActiveRecord::RecordNotUnique #DB VALIDATION
    loc = DB::Location.find(:first, :conditions => {latitude: lat.to_f, longitude: lng.to_f})
    raise "Error... No Location for #{lat.to_f} - #{lng.to_f}" if loc.nil?
  end
  
  DB::City.create name: name, ccode: ccode, location_id: loc.id, player_id: 1
end

# http://products.wolframalpha.com/api/explorer.html - 20k cities per account per month
# population firenze, reggello, siena, roma, viterbo, terni, napoli, milano, campagnano di roma, lizzano

def create_default_vals
  
  DB::Alliance.create name: "No Alliance"
  
  DB::Player.create name: "Free Lands", 
                new_password: "NULLABLE", 
                new_password_confirmation: "NULLABLE", 
                email: "test@test.test", 
                alliance_id: 1
  #UNITS          
  DB::Unit::Definition.create name: "Soldier",
                unit_type: "Infantry",
                attack_type: 0, 
                power: 1,
                defence: 1,
                movement_speed: 4,
                movement_cost: 0,
                cargo_capacity: 20,
                transport_capacity: 0
   
   DB::Unit::Definition.create name: "Special Forces",
                 unit_type: "Infantry",
                 attack_type: 0,
                 power: 5,
                 defence: 3,
                 movement_speed: 4,
                 movement_cost: 0,
                 cargo_capacity: 20,
                 transport_capacity: 0
                 
   DB::Unit::Definition.create name: "Granatier",
                unit_type: "Infantry",
                attack_type: 1,
                power: 15,
                defence: 1,
                movement_speed: 3,
                movement_cost: 0,
                cargo_capacity: 10,
                transport_capacity: 0
                 
   DB::Unit::Definition.create name: "Jeep",
                unit_type: "Vehicle",
                attack_type: 2,
                power: 40,
                defence: 10,
                movement_speed: 120,
                movement_cost: 40,
                cargo_capacity: 200,
                transport_capacity: 10         
   
   DB::Unit::Definition.create name: "Light Camion",
                unit_type: "Vehicle",
                attack_type: 0,
                power: 0,
                defence: 20,
                movement_speed: 80,
                movement_cost: 10,
                cargo_capacity: 2000,
                transport_capacity: 50  
                
   DB::Unit::Definition.create name: "Light Tank",
                unit_type: "Vehicle",
                attack_type: 0,
                power: 60,
                defence: 20,
                movement_speed: 80,
                movement_cost: 40,
                cargo_capacity: 100,
                transport_capacity: 5   
                
   DB::Unit::Definition.create name: "Heavy Camion",
                unit_type: "Vehicle",
                attack_type: 0,
                power: 0,
                defence: 35,
                movement_speed: 60,
                movement_cost: 15,
                cargo_capacity: 10000,
                transport_capacity: 100  
   

   DB::Unit::Definition.create name: "Heavy Tank",
                unit_type: "Vehicle",
                attack_type: 0,
                power: 140,
                defence: 40,
                movement_speed: 40,
                movement_cost: 80,
                cargo_capacity: 150,
                transport_capacity: 5
                
   
   #STRUCTURES
   DB::Structure::Definition.create name: "Market",
               description: "Produces Gold"
   
   DB::Structure::Definition.create name: "Foundry",
               description: "Produces Steel"
   
   DB::Structure::Definition.create name: "Refinery",
               description: "Produces Oil"
   
   DB::Structure::Definition.create name: "Bank",
               description: "Storage Room for Gold"
               
   DB::Structure::Definition.create name: "Warehouse",
               description: "Storage Room for Steel and Oil"
   
   DB::Structure::Definition.create name: "Barrak",
               description: "Produces Infantry Units"
               
   DB::Structure::Definition.create name: "Factory",
               description: "Produces Veicles"
              
   DB::Structure::Definition.create name: "Research Centre",
               description: "Produces Researches"

   DB::Structure::Definition.create name: "Bunker",
               description: "Increases Defence if City is Attacked"
               
               
   #RESEARCHES
   DB::Research::Definition.create name: "Infantry Weapon Upgrade",
               description: "to-be-added"
   
   DB::Research::Definition.create name: "Infrantry Armor Upgrade",
               description: "to-be-added"   
               
   DB::Research::Definition.create name: "Vehicle Weapon Upgrade",
               description: "to-be-added"
  
   DB::Research::Definition.create name: "Vehicle Armor Upgrade",
               description: "to-be-added"
               
   DB::Research::Definition.create name: "Construction Industry Tecniques",
               description: "to-be-added"   
   
   DB::Research::Definition.create name: "Espionage",
               description: "to-be-added"
   
   DB::Research::Definition.create name: "Engine Power",
               description: "to-be-added"
                           
end

def create_default_vals_after_location
    
  florence = DB::Location.create latitude: 43.7687324, longitude: 11.2569013  # firenze
  
  DB::City.create name: "Florence", ccode: "it", location_id: florence.id, player_id: 1
  
  paris = DB::Location.create latitude: 48.866667, longitude: 2.333333
    
  DB::City.create name: "Paris", ccode: "fr", location_id: paris.id, player_id: 1
  
  army = DB::Army.create location_id: florence.id,
                  player_id: 1,
                  is_moving: 0              
                  
  DB::Army.create location_id: florence.id,
                  player_id: 1,
                  is_moving: 1,
                  destination_id: paris.id
                  
#ARMY 1
  DB::Unit::ArmyUnit.create unit_id: 1,
                     army_id: 1,
                     player_id: 1,
                     number: 100 #100 soldiers
  
  DB::Unit::ArmyUnit.create unit_id: 3,
                      army_id: 1,
                      player_id: 1,
                      number: 20 #20 granatiers
                      
  DB::Unit::ArmyUnit.create unit_id: 5,
                      army_id: 1,
                      player_id: 1,
                      number: 10 #10 light camions

#ARMY 2
  DB::Unit::ArmyUnit.create unit_id: 2,
                      army_id: 2,
                      player_id: 1,
                      number: 50 #50 special forces
                      
  DB::Unit::ArmyUnit.create unit_id: 4,
                      army_id: 2,
                      player_id: 1,
                      number: 5 #5 jeeps
  
end

def step_2
  require "#{PATH}/config/environment"
  require "#{PATH}/db/recreate_tables"
  
  create_default_vals
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
  
  create_default_vals_after_location

  
end

# step_1
step_2

