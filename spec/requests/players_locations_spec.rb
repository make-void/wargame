require 'spec_helper'

describe "Players" do
  describe "Locations" do
  
    describe "GET /players/me/locations/:lat/:lng" do
            
      before :all do
        @fi = { latitude: 43.7687324, longitude: 11.2569013 } 
        @the_masterers = { name: "TheMasterers" }
        @cor3y = { name: "Cor3y", 
                      new_password: "daniel001", 
                      new_password_confirmation: "daniel001", 
                      email: "test1@test.test" }     
        @florence = { name: "Florence", ccode: "it" }
        
        @ally = DB::Alliance.create @the_masterers
        @player = DB::Player.create @cor3y.merge( alliance_id: @ally.id )
        @location = DB::Location.create @fi
        @city = DB::City.create @florence.merge(location_id: @location.id, player_id: @player.id)
      end
      
      it "should return current_player's locations" do
        url = "/players/me/locations/#{@fi[:latitude]}/#{@fi[:longitude]}" 
        data = get_json url
        data[:name].should == "Firenze"
      end
      
      
      after :all do
        @city.destroy
        @player.destroy
        @ally.destroy
        @location.destroy
      end
      
    end
    
  end
end

