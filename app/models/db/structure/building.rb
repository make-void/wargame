module DB
  module Structure
    class Building < ActiveRecord::Base
      set_table_name "wg_struct" 
      set_primary_keys "structure_id", "city_id"
      
      belongs_to :city, :class_name => "DB::City"
      belongs_to :definition, :foreign_key => "structure_id"
      
      PRODUCTION_STRUCTURES = {
        1 => :gold,
        2 => :steel, 
        3 => :oil
      }
      STORAGE_STRUCTURES = {
        4 => :gold,
        5 => [:steel, :oil]
      }
      
      
      before_save :update_database_cache #PARTENDO DAL PRESUPPOSTO CHE GLI OGGETTI VENGANO 'salvati' IN QUESTA TABELLA SOLO QUANDO COMPLETI
        
      private
     
      def update_database_cache()
        base_struct = DB::Structure::Definition.find(self.structure_id)
        next_lev_costs = LG::Structures.cost( base_struct, self.level + 1 )  
        
        #CACHE in db values for next level production
        self.next_lev_gold_cost = next_lev_costs[:gold]
        self.next_lev_steel_cost = next_lev_costs[:steel]
        self.next_lev_oil_cost = next_lev_costs[:oil]
        
        #SET new Production in the City Object
        unless PRODUCTION_STRUCTURES[self.structure_id].nil?
          base_city = DB::City.find(self.city_id)
          
          case PRODUCTION_STRUCTURES[self.structure_id]
            when :gold
              method = :gold_production
              base_prod = DB::City::BASE_GOLD_PROD
            when :steel
              method = :steel_production
              base_prod = DB::City::BASE_STEEL_PROD
            when :oil
              method = :oil_production
              base_prod = DB::City::BASE_OIL_PROD
            else 
              raise ArgumentException, "Need #{self.id} in #{PRODUCTION_STRUCTURES.keys}."
          end
          
          prod = LG::Structures.production( base_struct, self.level + 1)
          
          base_city.update_attributes method => ( prod + base_prod )
        end
        
        #SET new Storage entry in the City
        unless STORAGE_STRUCTURES[self.structure_id].nil?
          base_city = DB::City.find(self.city_id)
          
          case STORAGE_STRUCTURES[self.structure_id]
            when :gold
              methods = [:gold_storage_space]
            when [:steel, :oil]
              methods = [:steel_storage_space, :oil_storage_space]
            else 
              raise ArgumentException, "Need #{self.id} in #{STORAGE_STRUCTURES.keys}."
          end
          methods.map do |x|
            base_city.send(x.to_s + "=", ( self.level + 1 )*2500)
          end
          raise base_city.errors.inspect unless base_city.save
          
        end
      end
      
    end
  end
end