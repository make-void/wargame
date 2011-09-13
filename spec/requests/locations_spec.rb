require 'spec_helper'

load "#{Rails.root}/app/models/lg/location.rb"

describe "Locations" do
  
  describe "GET /" do
    
    before :each do
      @fi = { latitude: 43.7687324, longitude: 11.2569013 }
      @im = { latitude: 43.683333, longitude: 11.25 }
      @the_masterers = { name: "TheMasterers" }
      @florence = { name: "Florence", ccode: "it" }
      @impruneta = { name: "Impruneta", ccode: "it" }
      @location = DB::Location.create! @fi
      @location2 = DB::Location.create! @im
      @cor3y = { name: "Cor3y", 
                    new_password: "daniel001", 
                    new_password_confirmation: "daniel001", 
                    email: "test1@test.test" }
      @ally = DB::Alliance.create! @the_masterers
      @player = DB::Player.create! @cor3y.merge( alliance_id: @ally.id )
      @city = DB::City.create! @florence.merge(location_id: @location.id, player_id: @player.id)
      @city2 = DB::City.create! @impruneta.merge(location_id: @location2.id, player_id: @player.id)
    end
    
    it "locations/:lat/:lng" do

      url = "/locations/#{@fi[:latitude]}/#{@fi[:longitude]}"
      #request.headers["Content-Type"] = :json
      data = json_get url
      
      res = LG::Location.get_near( {}, @im.merge( radius: 50 ) )
      puts "loc", DB::Location.first.inspect   
      puts "view", View::CityLocation.all.inspect   
      puts "data", data.inspect
      
      data[:locations].should be_a(Array)
      data[:locations].size.should == 2 # W T F?!?
      data[:locations].each do |loc|
        #puts loc
        loc.should be_a(Hash)
        loc.symbolize_keys!
        loc[:latitude].should     be_a(Float)
        loc[:longitude].should    be_a(Float)
        loc[:id].should  be_a(Integer)
        loc[:id].should_not  be(0) # "".to_i
        
        puts "------------"
        puts loc[:type]
        ["city", "army"].should include(loc[:type])
        
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
    
    after :each do
      @city.destroy
      @city2.destroy
      @ally.destroy
      @player.destroy
      @location.destroy
      @location2.destroy
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

