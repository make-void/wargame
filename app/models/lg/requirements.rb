module LG
  module Requirements
    
    @@test = {}
    def soldier_requirements( player_id, city_id )
      buildings = DB::City.find(:first, conditions => {:player_id => player_id, :city_id => city_id})
      
    end
    
  end
end