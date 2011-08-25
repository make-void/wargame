module DB
  module Structure
    class Building < ActiveRecord::Base
      set_table_name "wg_struct" 
      set_primary_keys "structure_id", "city_id"
      
      belongs_to :city, :class_name => "DB::City"
      belongs_to :definition, :foreign_key => "structure_id"
    end
  end
end