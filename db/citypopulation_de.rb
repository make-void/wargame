# encoding: utf-8

class Deh
  
  require 'mechanize'
  require 'pp'
  require 'json'

  PATH = File.expand_path "../", __FILE__
  
  HOST = "http://www.citypopulation.de"
  
  HOME = "Europe.html"

  COUNTRY_SKIP_FROM = 2 # final
  COUNTRY_SKIP_FROM = 1000 # final
  REGION_SKIP_FROM = 1 # testing
  REGION_SKIP_FROM = 10000 # final
  
  
  # IMPORTANT: countries that are MISSING
  # ---

  # with door page
  #   Greece 
  #   Finland 
  #
  # without door page
  #   Estonia 
  #   Bosnia and Hercegovina
  #   Belarus
  #   Albania
  
  # ---
  
  def initialize
    @agent = Mechanize.new
    @agent.user_agent = "Mac Safari"
  end

  def get
    url = "#{HOST}/#{HOME}"
    puts url
    page = @agent.get url
    
    cities = []
    countries = get_countries page
    countries.each_with_index do |country, idx|
      next if idx > COUNTRY_SKIP_FROM
      regions = get_regions country
       regions.each_with_index do |region, idx|
        next if idx > REGION_SKIP_FROM
        cities << get_cities(region)
        
        # utf8 debug
        # cities.flatten.each do |city|
        #   puts city[:name].inspect
        # end
        
      end
    end
    cities.flatten!
    
    puts cities.count
    puts "writing it down!"
    File.open("#{PATH}/cities.json", "w"){ |f| f.write cities.to_json }
  end
  
  private
  
  def get_cities(region)
    url = "#{HOST}/#{region[:url]}"
    puts url
    page = @agent.get url    
    
    # puts page.body
    cities = []
    page.search("table#ts tr").each do |tr|
      tds = tr.search("td").map { |td| td.inner_text }
      # pp tds
      unless tds == []
        name = tds[0]
        name.gsub!(/\s+/, " ")
        pop = tds[5].to_i != 0 ? tds[5] : tds[4]
        #puts "CITY: #{name}\t\t\t\t\t\t\t\t#{pop} [#{region[:country]}]"
        cities << { name: name, pop: pop, region: region}
      end
    end
    cities

    # puts "CITIES OF REGION: #{region}"
    # puts cities.inspect
    # puts "-"*80
  end
  
  def get_regions(country)
    url = "#{HOST}/#{country[:url]}"
    puts url
    page = @agent.get url
    

    if page.search(".mcol") == []
      puts "Skipping #{country[:name]} - no cities and communes"
      return [] 
    end
    
    # puts page.body
    regions = []
    reg_elems = page.search(".cindex .mcol:last a")


    reg_elems.each do |region|
      name = region.inner_text 
      url = region["href"]
      regions << { name: name, url: url, country: country[:name] }
    end
    
    puts "COUNTRY: #{country[:name]} DOESNT HAZ CITIES" if regions == []
    regions
  end
  
  def get_countries(page)
    countries = []
    page.search(".cindex h2 a").each do |country|
      name = country.inner_text
      url = country["href"]
      countries << { name: name , url: url } unless url.nil?
    end
    countries
  end
  
  public
  
  def self.get
    new.get
  end
  
end

Deh.get