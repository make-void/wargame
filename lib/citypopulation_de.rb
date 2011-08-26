class Deh
  
  require 'mechanize'
  require 'pp'
  
  HOST = "http://www.citypopulation.de"
  
  HOME = "Europe.html"
  
  COUNTRY_SKIP_FROM = 1000 # testing
  REGION_SKIP_FROM = 1 # testing
  # SKIP_FROM = 10000 # final
  
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
      end
    end
    cities.flatten
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
      cities << tds
    end
    cities

    puts "-"*80    
    puts "CITIES OF REGION: #{region}"
    puts cities.inspect
    puts "-"*80
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
    page.search(".cindex .mcol:last a").each do |region|
      name = region.inner_text 
      url = region["href"]
      regions << { name: name, url: url }
    end
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