require 'spec_helper'


# load "#{Rails.root}/custom_helpers.rb"
load "#{Rails.root}/app/controllers/cities_controller.rb"
load "#{Rails.root}/app/models/lg/city.rb"
# load "#{Rails.root}/config/router.rb"


describe "Cities" do
  
  before :all do
    @fi = { latitude: 43.7687324, longitude: 11.2569013 }
    @the_masterers = { name: "TheMasterers" }
    @florence = { name: "Florence", ccode: "it" }
    @location = DB::Location.create! @fi
    @cor3y = { name: "Cor3y", 
                  new_password: "daniel001", 
                  new_password_confirmation: "daniel001", 
                  email: "test1@test.test" }
    @ally = DB::Alliance.create! @the_masterers
    @player = DB::Player.create! @cor3y.merge( alliance_id: @ally.id )
    @city = DB::City.create! @florence.merge(location_id: @location.id, player_id: @player.id)
  end
  
  it "should get player's cities" do
    data = json_get "/players/me/cities"
    
    data.should be_a(Array)
    data.size.should == 1
    city = data.first
    city.symbolize_keys!
    city[:name].should == @florence[:name]
    
    test_resources city[:production]
    test_resources city[:storage_space]
    test_resources city[:stored]
    
    city[:stats].should be_a(Hash)
    city[:stats]["power"].should be_a(Numeric)
    city[:stats]["defence"].should be_a(Numeric)
    
    city[:location].should be_a(Hash)
    city[:location]["id"].should be_a(Numeric)
    city[:location]["latitude"].should be_a(Numeric)
    city[:location]["longitude"].should be_a(Numeric)
    
  end
  
  it "should find a city by name" do
    city = "Florence"
    data = json_get "/cities/#{city}"
    data[:location]["latitude"].should == @fi[:latitude].to_s
    data[:location]["longitude"].should == @fi[:longitude].to_s
  end
  
  after :all do
    @city.destroy
    @ally.destroy
    @player.destroy
    @location.destroy
  end
  
  def test_resources(resources)
    resources.should be_a(Hash)
    resources["gold"].should be_a(Numeric)
    resources["steel"].should be_a(Numeric)
    resources["oil"].should be_a(Numeric)
  end
end