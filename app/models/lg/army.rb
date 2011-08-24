module LG
  class Army
    include Math
    
    attr_reader :units, :army
    
    def initialize( army_id )
      raise ArgumentError, "Need an ArmyID. Got #{army_id.inspect}" if army_id.nil?
      @army_id = army_id
      @army = DB::Army.find(@army_id)
      @units = ArmyUnit.find(:all, conditions: { army_id: @army_id} )
    end
    
    
    def debug_moving_tick( seconds = 3600 )
      
      distance_traveled = self.speed * (seconds/3600.to_f) #KM
      res = Helpers::Geolocation.new( @army.location, @army.destination, distance_traveled )
      res.move
      
      return res.to_json
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
    
    def consumption #TODO -> Check to reduce consumption if the speed is not MAX
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
    
    def overall_defence
      count = 0
      @units.each{|x| count += (x.defence * x.number) }
      return count    end
    
    def refresh!
      @army = DB::Army.find(@army_id)
      @units = ArmyUnit.find(:all, conditions: { army_id: @army_id})
      return true
    end
    
    def to_s
      @army.inspect + "\n" + @units.inspect
    end
    
      
  end
end