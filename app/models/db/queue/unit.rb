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
      
      def active? ; self.running ; end
      
      #starts the queue
      def start( unit_production_level, start_time = nil )
        self.update_attributes( 
          :started_at => start_time || Time.now, 
          :time_needed => LG::Unit.production_time( self.definition, unit_production_level )  * self.number
        )
      end
      
      #Destroys the queue object and returns the units created
      def finish!
        return false unless self.finished?
        v = { number: self.number, unit: self.definition }
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
      
      def started?
        !self.started_at.nil?
      end
      
    end
  end
end