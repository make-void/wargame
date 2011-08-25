module DB
  module Research
    class Upgrade < ActiveRecord::Base
      set_table_name "wg_techs" 
      set_primary_keys "tech_id", "player_id"
      
      belongs_to :player, :class_name => "DB::Player"
      belongs_to :definition
      
    end
  end
end