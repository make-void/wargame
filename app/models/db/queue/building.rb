module DB
  module Queue
    class Building < ActiveRecord::Base
      set_table_name "wg_struct_queue" 
      set_primary_keys "player_id", "structure_id", "city_id"
      
      belongs_to :city, :class_name => "DB::City", :foreign_key => :city_id
      belongs_to :player, :class_name => "DB::Player", :foreign_key => :player_id
      belongs_to :definition, :class_name => "DB::Structure::Definition", :foreign_key => :structure_id
          
      validates_presence_of :level
      validates_numericality_of :level
      
      def active? ; self.running ; end
      
    end
  end
end