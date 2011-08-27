#encoding: utf-8

path = File.expand_path "../../", __FILE__

require 'json'
require 'yaml'
require 'sequel'
require 'mysql2'
require 'pp'

DB_NAME = "wargame_cities"
DB_CONFIG = YAML.load( File.open("#{path}/config/database.yml") )["development"]
MYSQL_PASS = DB_CONFIG["password"] || ""

DB = Sequel.mysql(database: DB_NAME, user: "root", password: MYSQL_PASS, encoding: "utf8", charset: "utf8_general_ci")

DB_GAME = Sequel.mysql(database: DB_CONFIG["database"], user: "root", password: MYSQL_PASS, encoding: "utf8", charset: "utf8_general_ci")

cities = DB[:cities]
game_cities = DB_GAME[:wg_cities]


zeropop = cities.filter('pop <= ?', 0)
puts "Deleting #{zeropop.count} cities, population 0"
zeropop.delete()


puts "Top 100 populated cities"
ordereds = cities.reverse_order(:pop).limit(100)
puts "executing: #{ordereds.sql}"

ordereds.all.each do |city|
  match = city[:name].force_encoding("utf-8").match /ö/
  puts city[:name] if match
  
  # ISO-8859-1
  cit = game_cities.first(name: city[:name])
  if cit
    puts "found:\t#{cit[:name]}"
  else
    puts "not found:#{city[:name]}"
  end
end


####

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


##  ###

def import(line)

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