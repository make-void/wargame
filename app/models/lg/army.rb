module LG
  class Army
    include Math
    
    attr_reader :units, :army
    
    
    def self.all( player )
      player.armies.find(:all, include: [:units, :location]).map do |army|
        lg_army = new(army)
        lg_army.description
      end
    end
    
    def initialize(army)
      @army = army        
      @units = army.units
    end
    
    
    def description      
      loc = army.location
      army = { 
        id: @army.id,
        units: [], 
        moving: @army.is_moving?, 
        location: { latitude: loc.latitude.to_f, longitude: loc.longitude.to_f, id: loc.id },
        speed: @army.speed,
        # updated_at: @army.updated_at,
        resources: {
          gold: @army.gold_stored,
          steel: @army.gold_stored,
          oil: @army.gold_stored,
        },
      }
      @units.each do |unit|
        army[:units] << {
          number: unit.number,
          type_id: unit.unit_id,
          # updated_at: unit.updated_at,
        }
      end
      
      return army
    end
    
    
    def debug_moving_tick( seconds = 3600 ) #TODO -> Add estimated time to res result, and make all the methods CLASS methods in the Geolocation class...
      
      distance_traveled = self.speed * (seconds/3600.to_f) #KM
      return ActiveSupport::JSON.encode( Helpers::Geolocation.move( @army.location, @army.destination, distance_traveled ) )
    end
    
    def capacity
      count = 0
      @units.each{|x| count += (x.resources_transported * x.number) }
      return count
    end
    
    def speed
      veicles = @units.select{|x| x.unit_type == "Vehicle" }
      infantry = @units.select{|x| x.unit_type == "Infantry" }
      
      
      transport_capacity = 0
      veicles.each{|x| transport_capacity += ( x.people_transported * x.number ) }
      
      infantry_number = 0
      infantry.each{|x| infantry_number += x.number }
      
      if transport_capacity >= infantry_number
        return veicles.map(&:speed).min
      else
        return infantry.map(&:speed).min
      end  
    end
    
    def consumption
      count = 0
      army_speed = self.speed
      @units.each do |x|
        if x.cost != 0 #I consume something by moving
          if army_speed == x.speed #I'm moving @ max speed
            count += x.consumption
          else #This veicle is moving not as fast as he can
            count += (x.consumption*army_speed/x.speed.to_f)
          end
        end
      end
      return count
    end
    
    def overall_power
      count = 0
      @units.each{|x| count += (x.power * x.number) }
      return count
    end
    
    def overall_defense
      count = 0
      @units.each{|x| count += (x.defense * x.number) }
      return count    
    end
    
    def refresh!
      @army = DB::Army.find @army.id
      @units = View::ArmyUnit.find(:all, conditions: { army_id: @army.id} )
      return true
    end
    
    def to_s
      @army.inspect + "\n" + @units.inspect
    end
    
      
  end
end