require 'json'

path = File.expand_path "../../", __FILE__
PATH = path

pop_cities = JSON.parse File.open("cities.json").read # population data


def make_index(array_of_hashes, key, value, &block) 
  array = array_of_hashes
  index = {}
  array.each do |hash|
    val = block.call hash[value]
    index[hash[key]] = val
  end
  index
end

index = make_index pop_cities, "name", "pop" do |pop|
  pop.gsub(/,|\./, '').to_i
end


class Updater
  
  def initialize(table)
    require "#{PATH}/config/environment"
    @table = table
  end
  
  def query(sql)
    ActiveRecord::Base.connection.execute sql
  end
  
  def destroy(key)
    "UPDATE `#{@table}` SET `#{key}` = '0'"
  end
  
  def update(finder, set)
    # TODO: accept an hash with multiple key/values
    set_key       = set.keys.first
    set_value     = set.values.first
    finder_key = finder.keys.first
    finder_value = finder.values.first
    finder_value  = finder_value.gsub(/\'/, "\\'")
    sql = "UPDATE #{@table} SET #{set_key} = #{set_value} WHERE #{finder_key} = '#{finder_value}';"
    query sql
    
    #puts sql
  end
  
end  



counter = 0
updater = Updater.new "wg_cities"
updater.destroy "pts"

results = []
lat_lngs = {}
names = {}


File.open("#{PATH}/db/europe_cities.txt").each_line do |line|
  
  split = line.split(",")
  ccode, name, lat, lng = split[0], split[2], split[5], split[6]
  name = name.gsub(/(\(.+\))|\[.+\]|\s+/, '').strip
  pop = index[name]
  
  if pop
    #updater.update( { name: name }, { pts: index[name] } )
    pop_check = lat_lngs["#{lat}_#{lng}"]
    pop_major = pop > pop_check unless pop_check.nil?
    if pop_check.nil? || pop_major
      result = [ccode, name, pop, lat, lng].join(",") 
      
      unless names[name]
        results.delete result if pop_major
        results << result
        counter += 1
        lat_lngs["#{lat}_#{lng}"] = pop
        names[name] = true
      end
    end
  end

end

#results = results.join("\n")

File.open("cities_pop.json", "w"){ |f| f.write results.to_json }
puts "wrote: #{counter} cities"