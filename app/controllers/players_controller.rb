class PlayersController < ApplicationController
  
  layout nil
  
  def index
    
  end
  
  def me
    
    # Player.auth(email, pass) || Player.find(fb_id: x)
    
    # todo: create LG::Player if you like to
    fields = [:alliance_id, :created_at, :email, :name, :player_id]
    data = DB::Player.select(fields).where(name: "Cor3y").first.attributes
    render json: data
  end
  
  # etc...
  
end