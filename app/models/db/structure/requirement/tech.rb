module DB
  module Structure
    module Requirement
      class Tech < ActiveRecord::Base
        set_table_name "wg_struct_tech_req_defs" 
        set_primary_keys "structure_id", "req_tech_id"

        validates_presence_of :level
        validates_numericality_of :level

        belongs_to :structure, :class_name => "DB::Structure::Definition", :foreign_key => :structure_id       
        belongs_to :required_object, 
                   :class_name => "DB::Research::Definition", 
                   :foreign_key => :req_tech_id
         
      end
    end
  end
end