module DB
  module Queue
    class Tech < ActiveRecord::Base
      set_table_name "wg_tech_queue" 
      set_primary_keys "player_id", "tech_id", "city_id"
      
      belongs_to :city, :class_name => "DB::City", :foreign_key => :city_id
      belongs_to :player, :class_name => "DB::Player", :foreign_key => :player_id
      belongs_to :definition, :class_name => "DB::Research::Definition", :foreign_key => :tech_id
          
      validates_presence_of :level
      validates_numericality_of :level
      
      def active? ; self.running ; end
      
    end
  end
end