module DB # Database
  class City < ActiveRecord::Base
    set_table_name "wg_cities" 
    set_primary_key "city_id"
    
    validates_presence_of :name
    
    belongs_to :location
    belongs_to :player
    
    has_many :units, :class_name => "DB::Unit::CityUnit"
    has_many :buildings, :class_name => "DB::Structure::Building"
    
    
    BASE_GOLD_PROD = 45
    BASE_STEEL_PROD = 35
    BASE_OIL_PROD = 15
    
    after_initialize :update_city_if_needed #TODO -> Check if it's enought to handle like this
    before_create { self.last_update_at = Time.now }
    
    
    
    private
    
    #Called at every find on this City Object, when the Object is Initialized
    #If we want to cache objects in MEM, this needs to be changed...
    def update_city_if_needed
      if ( !self.last_update_at.nil? ) && ( self.player_id != 1 )
        hours_passed_since_last_update = ( ( Time.now - self.last_update_at ) / 3600 )
        if hours_passed_since_last_update >= 1          
          update_production( hours_passed_since_last_update.floor )
          self.last_update_at = Time.now
          self.save
        end
      end
    end
    
    #Updated all production entries if needed for this City Object
    def update_production( hours )
      self.gold_stored  = self.gold_stored   + ( self.gold_production * hours)
      self.steel_stored = self.steel_stored  + ( self.steel_production * hours)
      self.oil_stored   = self.oil_stored    + ( self.oil_production * hours)
            
      self.gold_stored  = self.gold_storage_space  if self.gold_stored  > self.gold_storage_space
      self.steel_stored = self.steel_storage_space if self.steel_stored > self.steel_storage_space
      self.oil_stored   = self.oil_storage_space   if self.oil_stored   > self.oil_storage_space
    end
    
    
  end
end

# properties:
#
# id
# name
# location_id
