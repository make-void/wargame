module DB
  module Structure
    class Definition < ActiveRecord::Base
      set_table_name "wg_struct_defs" 
      set_primary_key "structure_id"
          
      validates_uniqueness_of :name
      validates_presence_of :name, :description
      
      has_many :buildings, :foreign_key => :structure_id
      
      has_many :tech_reqs, :class_name => "DB::Structure::Requirement::Tech", :foreign_key => :structure_id
      has_many :building_reqs, :class_name => "DB::Structure::Requirement::Building", :foreign_key => :structure_id
      
      COST_ADVANCEMENT = {
        0 => "Standard",
        1 => "Medium",
        2 => "High",
        3 => "Highest"
      }
      
      
      def cost_advancement_to_string
        COST_ADVANCEMENT[self.cost_advancement_type]
      end
      
    end
  end
end