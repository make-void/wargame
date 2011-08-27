# USAGE:

# ruby citypopulation_de.rb
# ruby cities_to_db.rb (you may need to set MYSQL_PASS first)


path = File.expand_path "../", __FILE__

require 'json'
require 'sequel'


MYSQL_PASS = ""
DB_NAME = "wargame_cities"

db = Sequel.mysql(user: "root", password: MYSQL_PASS)

CITIES_PATH = "#{path}/cities.json"

db.run "DROP DATABASE IF EXISTS #{DB_NAME}"
db.run "CREATE DATABASE #{DB_NAME}"

DB = Sequel.mysql(database: DB_NAME, user: "root", password: MYSQL_PASS)

DB.create_table :cities do
  primary_key :id
  String :name
  Integer :pop
  String :country
  String :region
end

cities = DB[:cities]
#{"name":"Andau","pop":"2,514","region":{"name":"Burgenland","url":"php/austria-burgenland.php","country":"Austria"}}

datas = JSON.parse File.read(CITIES_PATH)

datas.each do |data|
  city = { name: data["name"], pop: data["pop"], country: data["region"]["country"], region: data["region"] }
  cities.insert city
end 

# filtering out bad content

cities #..