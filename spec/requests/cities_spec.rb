require 'spec_helper'

# path = File.expand_path "../../", __FILE__
# load "#{path}/custom_helpers.rb"

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
  
  it "should find a city by name" do
    city = "Florence"
    data = get_json "/cities/#{city}"
    data[:location]["latitude"].should == @fi[:latitude].to_s
    data[:location]["longitude"].should == @fi[:longitude].to_s
  end
  
  after :all do
    @city.destroy
    @ally.destroy
    @player.destroy
    @location.destroy
  end
end