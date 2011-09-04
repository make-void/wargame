require 'spec_helper'

describe "Queues" do
  
  before :all do
    @fi = { latitude: 43.7687324, longitude: 11.2569013 } 
    @the_masterers = { name: "TheMasterers" }
    @cor3y = { name: "Cor3y", 
                  new_password: "daniel001", 
                  new_password_confirmation: "daniel001", 
                  email: "test1@test.test" }     
    @florence = { name: "Florence", ccode: "it" }
    
    @ally = DB::Alliance.create! @the_masterers
    @player = DB::Player.create! @cor3y.merge( alliance_id: @ally.id )
    @location = DB::Location.create! @fi
    @city = DB::City.create! @florence.merge(location_id: @location.id, player_id: @player.id)
    # ----
    @structure_type = DB::Structure::Definition.first
    structure = { city_id: @city.id, structure_id: @structure_type.id, player_id: @player.id}
    @structure = DB::Structure::Building.create! structure
    @queue = DB::Queue::Building.create! structure
  end
  
  it "index" do
    
    # GET /players/me/cities/:id/queues
    data = get_json "/players/me/cities/#{@city.id}/queues"
    data.keys.should == [:units, :structs, :techs]
    p data[:structs]
    
  end
  
  it "create" do
    # POST /players/me/queues/:type/:id/
  end
  
  it "destroy" do
    
  end
  
  after :all do
    @queue.destroy
    @structure.destroy
    @city.destroy
    @player.destroy
    @ally.destroy
    @location.destroy
  end
end