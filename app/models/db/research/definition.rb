module DB
  module Research
    class Definition < ActiveRecord::Base
      set_table_name "wg_tech_defs" 
      set_primary_key "tech_id"
          
      validates_uniqueness_of :name
      validates_presence_of :name, :description
      
      has_many :upgrades, :foreign_key => :tech_id
      
    end
  end
end