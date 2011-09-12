require 'spec_helper'

describe "Locations" do
  
  describe "GET /" do
    
    before(:each) { @fi = [43.7687324, 11.2569013] }
    
    it "locations/:lat/:lng" do
      url = "/locations/#{@fi.join("/")}"
      #request.headers["Content-Type"] = :json
      data = json_get url
      
      data[:locations].should be_a(Array)
      data[:locations].each do |loc|
        #puts loc
        loc.should be_a(Hash)
        loc.symbolize_keys!
        loc[:latitude].should     be_a(Float)
        loc[:longitude].should    be_a(Float)
        loc[:id].should  be_a(Integer)
        loc[:id].should_not  be(0) # "".to_i
        
        # FIXME: move this in a request with cities to be sure we have a city 
        city = loc[:city]
        unless city.nil?
          city.should be_a(Hash)        
          city.symbolize_keys!   
          city[:id].should be_a(Integer)
          city[:id].should_not  be(0)
          city[:name].should be_a(String)
          city[:pts].should be_a(Integer)
        end

        # FIXME: move this in a request with armies to be sure we have an army        
        army = loc[:army]
        unless army.nil?
          army.should be_a(Hash)        
          army.symbolize_keys!
          army[:id].should be_a(Integer)
          army[:id].should_not  be(0)
        end
        
        player = loc[:player]
        player.should be_a(Hash)        
        player.symbolize_keys!
        player[:id].should be_a(Integer)
        player[:id].should_not  be(0)
        alliance = player[:alliance]
        alliance.should be_a(Hash)        
        alliance.symbolize_keys!
        alliance[:id].should be_a(Integer)
        alliance[:id].should_not  be(0)
      end 
      # { "locations":
      #   [{"latitude":44.433333,"longitude":11.283333,"location_id":3640,"city":{"city_id":3658,"name":"Borgo Nuovo","pts":0,"ccode":"it"}]
      # }
    end
    
    it "locations/:lat/:lng raises an error with blank coordinates" do
      
    end
    
    # it "locations/:lat/:lng/cities"
    # 
    # it "locations/:lat/:lng/cities"
    
  end

end

# examples: 
    
# get "/widgets/new"
# post "/widgets", :widget => {:name => "My Widget"}
# follow_redirect!
# response.should redirect_to(assigns(:widget))
# response.should render_template(:show)
# response.body.should include("Widget was successfully created.")

