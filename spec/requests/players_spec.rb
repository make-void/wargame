require 'spec_helper'

describe "Players" do
  
  describe "GET /me" do
    
    # let(:user) { Factory(:user) }
    
    before :all do
      @ally = DB::Alliance.create! name: "TheMasterers"
      @player = DB::Player.create! name: "Cor3y", 
                    new_password: "daniel001", 
                    new_password_confirmation: "daniel001", 
                    email: "test1@test.test", 
                    alliance_id: @ally.id
    end
     
    it "should return current_player" do
      data = json_get "/players/me"
      data[:name].should == "Cor3y"
    end
    
    after :all do
      @player.destroy
      @ally.destroy      
    end
    
  end

end

