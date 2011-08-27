#encoding: utf-8

# USAGE:

# ruby citypopulation_de.rb
# ruby cities_to_db.rb


path = File.expand_path "../../", __FILE__

require 'json'
require 'yaml'
require 'sequel'

# BREAK_AT = 1000     # debug
BREAK_AT = 100000 # final


MYSQL_PASS = YAML.load( File.open("#{path}/config/database.yml") )["development"]["password"] || ""

DB_NAME = "wargame_cities"

db = Sequel.mysql(user: "root", password: MYSQL_PASS)

CITIES_PATH = "#{path}/db/cities.json"

db.run "DROP DATABASE IF EXISTS #{DB_NAME}"
db.run "CREATE DATABASE #{DB_NAME}"

DB = Sequel.mysql(database: DB_NAME, user: "root", password: MYSQL_PASS, encoding: "utf8", charset: "utf8_general_ci")

# DB.create_table :cities do
#   primary_key :id
#   String :name
#   Integer :pop
#   String :country
#   String :region
# end

DB << "CREATE TABLE `cities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  `pop` int(11) DEFAULT NULL,
  `country` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  `region` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=100003 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;"

cities = DB[:cities]
#{"name":"Andau","pop":"2,514","region":{"name":"Burgenland","url":"php/austria-burgenland.php","country":"Austria"}}

# ISO-8859-1 ma anche no lo devo encodare prima
datas = JSON.parse File.open(CITIES_PATH, "r:UTF-8").read#.encode("UTF-8")

datas.each_with_index do |data, idx|
  city = { name: data["name"], pop: data["pop"].gsub(/,|\./, ''), country: data["region"]["country"], region: data["region"] }
  #puts data["name"]
  cities.insert city
  break if idx > BREAK_AT
end 

