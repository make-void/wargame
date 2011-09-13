require 'spec_helper'


load "#{Rails.root}/app/controllers/armies_controller.rb"
load "#{Rails.root}/app/models/lg/army.rb"


describe "Armies" do
  
  before :all do
    @near_florence = { latitude: 43.76, longitude: 11.2533 }
    @the_masterers = { name: "TheMasterers" }
    @location = DB::Location.create! @near_florence
    @cor3y = { name: "Cor3y", 
                  new_password: "daniel001", 
                  new_password_confirmation: "daniel001", 
                  email: "test1@test.test" }
    @ally = DB::Alliance.create! @the_masterers
    @player = DB::Player.create! @cor3y.merge( alliance_id: @ally.id )
    @army = DB::Army.create! location_id: @location.id, player_id: @player.id
  end
  
  it "should get player's armies" do
    data = json_get "/players/me/armies"
    
    data.should be_a(Array)
    data.size.should == 1
    army = data.first
    army.symbolize_keys!
    
    army[:id].should be(@army.id)
    army[:moving].should be(false)
    army[:location]["id"].should be(@location.id)
    army[:location]["latitude"].should == @location.latitude.to_f
    army[:location]["longitude"].should == @location.longitude.to_f
    army[:speed].should eql(@army.speed)
    army[:resources].should be_a(Hash)
    army[:resources]["gold"].should be_a(Integer)
    army[:resources]["oil"].should be_a(Integer)
    army[:resources]["steel"].should be_a(Integer)
    army[:units].should be_a(Array)
    # TODO: create unit in before block and test them here
  end
  
  
  after :all do
    @army.destroy
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