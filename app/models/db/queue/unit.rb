module DB
  module Queue
    class Unit < ActiveRecord::Base
      set_table_name "wg_unit_queue" 
      set_primary_keys "player_id", "unit_id", "city_id"
      
      belongs_to :city, :class_name => "DB::City", :foreign_key => :city_id
      belongs_to :player, :class_name => "DB::Player", :foreign_key => :player_id
      belongs_to :definition, :class_name => "DB::Unit::Definition", :foreign_key => :unit_id
          
      validates_presence_of :level
      validates_numericality_of :level
      
      before_create { started_at = Time.now }
      
      def active? ; self.running ; end
      
      
      #CONCEPT:
      # => Something Adds this to the Queue
      # => First item in queue ? START : Nothing
      # => (LAZY APPROACH) Every Time the items are needed (attack or view), UPDATE, and in case START NEXT
      # => Real Time Approach: background process maps over every queue item and UPDATES, in case START NEXT
      
      
      #starts the queue. Does not check for requirements
      def start(start_time = nil )
        
        unit_production_level = production_building_level()
        
        self.update_attributes( 
          :started_at => start_time || Time.now, 
          :time_needed => LG::Unit.production_time( self.definition, unit_production_level )  * self.number,
          :running => true
        )
      end
      
      #Units in queue may be more than one... Pull out already created units if needed (combat? refresh?)
      #If in the meantime the Barrak/Factory was updated, update the time needed entry!
      def update()
        return false unless self.started? #Cannot Do it...
        return self.finish! if self.finished? #If Finished, return all DATA.
        
        update_time = Time.now #Save this in case we loose a second for problems in the meantime
        passed_time_in_seconds = ( Time.now - self.started_at ).floor
        time_per_unit = ( self.time_needed / self.number ) 
        
        if passed_time_in_seconds >= time_per_unit
          units_done = ( passed_time_in_seconds / time_per_unit.to_f ).floor #Get the units already Created
          unit_production_level = production_building_level() #Reset Timing in case the structure was updated in the meantime

          self.update_attributes(
            #Set new Time
            :started_at => update_time,
            #Update Time Needed
            :time_needed => LG::Unit.production_time( self.definition, unit_production_level )  * ( self.number - units_done ),
            #Update Number of Units Missing
            :number => ( self.number - units_done )
          )
          
          return { number: units_done, unit: self.definition, status: { time_needed: self.time_needed, number: self.number, finished: false } }
        else
          return false
        end

      end
      
      #Destroys the queue object and returns the units created
      def finish!
        return false unless self.finished?
        v = { number: self.number, unit: self.definition, status: { time_needed: 0, number: 0, finished: true } }
        self.destroy
        return v
      end
      
      #returns true if finished
      def finished?
        return false unless self.started?
        return ( self.finished_at >= Time.now )
      end
      
      #calculates time the item is done
      def finished_at
        return nil unless self.started?
        return self.started_at + self.time_needed.seconds
      end
      
      def active?
        !self.started_at.nil?
      end
      
      private
      
      def production_building_level()
        begin
          prod_struct = DB::Structure::Building.find(:first, :conditions => { 
                                                      city_id: self.city_id,
                                                      structure_id: DB::Unit::Definition::PRODUCTION_CENTRE_ID[self.definition.unit_type],
                                                      player_id: self.player_id
                                                    }
                                    )
        rescue ActiveRecord::RecordNotFound
          raise ArgumentError, "No Building to Create #{self.definition.name} unit in City: #{city_id} for Player: #{player_id}"
        end
        return prod_struct.level
      end
      
    end
  end
end