# encoding: utf-8

require 'json'

# { "code": "RU",	"name": "Russian Federation"                          },
# { "code": "IS",	"name": "Iceland"                                     },
# { "code": "IE",	"name": "Ireland"                                     },
# { "code": "UK",	"name": "United Kingdom"                              },
# { "code": "NO", "name": "Norway"                                      },
# { "code": "SE", "name": "Sweden"                                      },
# { "code": "FI", "name": "Finland"                                     },
# { "code": "TR",	"name": "Turkey"                                      },

ccodes = JSON.parse File.read("country_codes.json")
ccodes = ccodes.map{|c| c["code"]}.map{ |c| c.downcase }

require 'fileutils'
FileUtils.rm "europe_cities.txt"
file = File.open("europe_cities.txt", "a:UTF-8")

File.open("worldcitiespop.txt", "r:UTF-8").each_line do |line|
  file.write line if ccodes.include? line.split(/,/)[0]
end

puts `wc -l europe_cities.txt`