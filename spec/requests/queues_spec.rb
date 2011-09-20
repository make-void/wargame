require 'spec_helper'

load "#{Rails.root}/app/controllers/queues_controller.rb"
load "#{Rails.root}/app/models/db/queue/building.rb"
load "#{Rails.root}/app/models/db/queue/unit.rb"
load "#{Rails.root}/app/models/db/queue/tech.rb"
load "#{Rails.root}/app/models/db/city.rb"
load "#{Rails.root}/app/models/lg/queue/city_queue.rb"
load "#{Rails.root}/app/models/lg/queue/building_queue.rb"
load "#{Rails.root}/app/models/modules/queue.rb"

load "#{Rails.root}/config/routes.rb"

describe "Queues" do
  
  before :each do
    @fi = { latitude: 43.7687324, longitude: 11.2569013 } 
    @the_masterers = { name: "TheMasterers" }
    @cor3y = { name: "Cor3y", 
                  new_password: "daniel001", 
                  new_password_confirmation: "daniel001", 
                  email: "test1@test.test" }     
    @florence = { name: "Florence", ccode: "it" }
    @level = 1
    
    @ally = DB::Alliance.create! @the_masterers
    @player = DB::Player.create! @cor3y.merge( alliance_id: @ally.alliance_id )
    @location = DB::Location.create! @fi
    @city = DB::City.create! @florence.merge(location_id: @location.location_id, player_id: @player.player_id)
    # ----
    @structure_type = DB::Structure::Definition.first
    @structure_args = { city_id: @city.city_id, structure_id: @structure_type.id, player_id: @player.player_id}
    @structure = DB::Structure::Building.create! @structure_args
    # DB::Queue::Building.new.start @level # TODO: test the queue but elsewhere (model spec?)
  end
  
  def create_queue 
    #TODO --> Create Queue Object trough the CityQueue, cause it should remove the proper number of money from the city
    @queue = DB::Queue::Building.create! @structure_args.merge( level: @level, time_needed: 0 )
  end
  
  it "index" do
    create_queue
    # GET /players/me/cities/:id/queues    
    data = json_get "/players/me/cities/#{@city.id}/queues"
    struct = data.first.symbolize_keys
    struct[:city_id].should be(@city.city_id)
    struct[:structure_id].should be(@structure_type.structure_id)
    struct[:level].should be(@level)
    struct[:type].should == "struct"
    # structs[:time_needed].should be(?)        
  end
  
  it "create" do
    # POST players/me/cities/:city_id/queues/:type/:id
    type = "struct"
    type_id = DB::Structure::Definition.last.id
    data = json_post "/players/me/cities/#{@city.id}/queues/#{type}/#{type_id}"
    data[:time_needed].should > 0
    data[:started].should be_a(Boolean) # TODO: write matcher be_a_timestring
  end
  
  it "destroy" do
    create_queue
    type = "struct"
    type_id = DB::Structure::Definition.last.id
    args = { object_id: @structure.structure_id, player_id: @player.player_id, level_or_number: @level }
    data = json_delete "/players/me/cities/#{@city.id}/queues/#{type}", args
    data[:success].should == true
    #TODO -> it should check if the proper number of money was given back to city, keeping in mind the CAP for the storage
  end
  
  after :each do
    DB::Queue::Building.destroy_all
    @structure.destroy
    @city.destroy
    @player.destroy
    @ally.destroy
    @location.destroy
  end
end