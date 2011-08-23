module DB # Database
  class Alliance < ActiveRecord::Base
    set_table_name "wg_alliances" 
    set_primary_key "alliance_id"
    
    
    validates_presence_of :name
    validates_uniqueness_of :name
  
  end
end