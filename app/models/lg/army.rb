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
      
      earth_radius = Geocoder::Calculations::EARTH_RADIUS #KM
      distance_travelled = self.speed * (seconds/seconds.to_f) #KM
      
      angular_distance = distance_travelled/earth_radius
            
      starting_point = @army.location
      arrival_point = @army.destination
      
      bearing = Geocoder::Calculations.bearing_between(starting_point, arrival_point)#, method: :spherical)
      
      #var y = Math.sin(dLon) * Math.cos(lat2);
      #var x = Math.cos(lat1)*Math.sin(lat2) -
      #        Math.sin(lat1)*Math.cos(lat2)*Math.cos(dLon);
      #var brng = Math.atan2(y, x)
            
      start_lat = starting_point.latitude.to_f
      start_long = starting_point.longitude.to_f
            
      result = { 
        bearing: bearing,
        starting_location: [ start_lat, start_long ],
        arrival_location: [ arrival_point.latitude.to_f, arrival_point.longitude.to_f ]
      }
      

      final_latitude = Math.asin( ( Math.sin(start_lat) * Math.cos(angular_distance) ) + ( Math.cos(start_lat) * Math.sin(angular_distance) * Math.cos(bearing)) )
      final_longitude = start_long + Math.atan2( ( Math.sin(bearing) * Math.sin(angular_distance) * Math.cos(start_lat) ), ( Math.cos(angular_distance) - ( Math.sin(start_lat) * Math.sin(final_latitude) ) ) )
      
      result[:middle_point] = [final_latitude, final_longitude]
      
      return result
      #lat2 = asin(sin(lat1)*cos(d/R) + cos(lat1)*sin(d/R)*cos(θ))
      #lon2 = lon1 + atan2(sin(θ)*sin(d/R)*cos(lat1), cos(d/R)−sin(lat1)*sin(lat2))
      #θ is the bearing (in radians, clockwise from north);
      #d/R is the angular distance (in radians), where d is the distance travelled and R is the earth’s radius
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
            #x = consumption*real_speed/max_speed
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



# module Location
#   def ArReadOnly.included(classe_di_arrivo)
#     classe_di_arrivo.class_eval do
#       extend ClassMethods if AR_READONLY
#       include InstanceMethods if AR_READONLY
#     end
#   end
#   
#   module ClassMethods
#   
#   end
#   
#   module InstanceMethods
#       def readonly? ; true ; end
#   end
# end