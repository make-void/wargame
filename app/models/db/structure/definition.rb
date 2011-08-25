module DB
  module Structure
    class Definition < ActiveRecord::Base
      set_table_name "wg_struct_defs" 
      set_primary_key "structure_id"
          
      validates_uniqueness_of :name
      validates_presence_of :name, :description
      
    end
  end
end