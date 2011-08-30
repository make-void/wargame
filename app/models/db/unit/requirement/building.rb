module DB
  module Unit
    module Requirement
      class Building < ActiveRecord::Base
        set_table_name "wg_unit_struct_req_defs" 
        set_primary_keys "unit_id", "req_structure_id"

        validates_presence_of :level
        validates_numericality_of :level

        belongs_to :structure, :class_name => "DB::Unit::Definition", :foreign_key => :unit_id       
        belongs_to :required_object, 
                   :class_name => "DB::Structure::Definition", 
                   :foreign_key => :req_structure_id
         
      end
    end
  end
end