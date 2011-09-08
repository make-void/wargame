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
    
    def overall_power
      count = 0
      units.each{|x| count += (x.power * x.number) }
      return count
    end
    
    def overall_defense
      count = 0
      units.each{|x| count += (x.defense * x.number) }
      return count    
    end
    
    # hash = {:gold => x, :steel => y, :oil => z}
    def has_resources?( hash )
      gold = self.gold_stored >= hash[:gold]
      steel = self.steel_stored >= hash[:steel]
      oil = self.oil_stored >= hash[:oil]
      
      return true if gold && steel && oil
      return false
    end

    # hash = {:gold => x, :steel => y, :oil => z}
    def remove_resources( hash )
      return false unless has_resources?(hash)
      return self.update_attributes(
        :gold_stored => (self.gold_stored - hash[:gold]),
        :steel_stored => (self.steel_stored - hash[:steel]),
        :oil_stored => (self.oil_stored - hash[:oil])
      )
    end
    
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
