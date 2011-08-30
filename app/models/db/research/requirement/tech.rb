module DB
  module Research
    module Requirement
      class Tech < ActiveRecord::Base
        set_table_name "wg_tech_tech_req_defs" 
        set_primary_keys "tech_id", "req_tech_id"

        validates_presence_of :level
        validates_numericality_of :level

        belongs_to :tech, :class_name => "DB::Research::Definition", :foreign_key => :tech_id       
        belongs_to :required_object, :class_name => "DB::Research::Definition", :foreign_key => :req_tech_id
         
      end
    end
  end
end