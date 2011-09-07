module DB
  module Research
    class Upgrade < ActiveRecord::Base
      set_table_name "wg_techs" 
      set_primary_keys "tech_id", "player_id"
      
      belongs_to :player, :class_name => "DB::Player"
      belongs_to :definition
      
      before_save :update_database_cache
      
      def self.find_building_speed_research( player_id )
        obj = self.find(:first, :conditions => {:player_id => player_id, :tech_id => 5})
        return 0 if obj.nil?
        return obj.level
      end
      
      
      private
      
      def update_database_cache()
        base_res = DB::Research::Definition.find(self.tech_id)
        next_lev_costs = LG::Research.cost( base_res, self.level + 1 )  
      
        #CACHE in db values for next level production
        self.next_lev_gold_cost = next_lev_costs[:gold]
        self.next_lev_steel_cost = next_lev_costs[:steel]
        self.next_lev_oil_cost = next_lev_costs[:oil]
      end
      
      
    end
  end
end