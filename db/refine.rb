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

require "#{PATH}/db/default_values"
include DefaultValues


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

