module LG
  class Army
    include Math
    
    ToDegree = lambda {|x| return ( x * 180 / Math::PI ) }
    ToRad = lambda {|x| return ( x * Math::PI / 180.to_f ) }
    
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
                  
      starting_point = @army.location
      arrival_point = @army.destination
      
      lat1 = starting_point.latitude.to_f
      lon1 = starting_point.longitude.to_f
            
      lat2 = arrival_point.latitude.to_f
      lon2 = arrival_point.longitude.to_f
      
      result = { 
        starting_location: [ lat1, lon1 ],
        arrival_location: [ lat2, lon2 ]
      }
      
      #TODAL DISTANCE
      #a = sin²(Δlat/2) + cos(lat1).cos(lat2).sin²(Δlong/2)
      #c = 2.atan2(√a, √(1−a))
      #d = R.c
      def distance_of_points(lat1 ,lat2, lon1, lon2)
        dlat = ToRad.call(lat2-lat1)
        dlon = ToRad.call(lon2-lon1)
        
        lat1 = ToRad.call(lat1)
        lat2 = ToRad.call(lat2)
        lon1 = ToRad.call(lon1)
        lon2 = ToRad.call(lon2)
        
        a = sin(dlat/2) * sin(dlat/2) + sin(dlon/2) * sin(dlon/2) * cos(lat1) * cos(lat2)
        c = 2 * atan2( sqrt(a), sqrt(1-a))
        return Geocoder::Calculations::EARTH_RADIUS * c        
      end
      
      def bearing_of_points(lat1, lat2, lon1, lon2)
        
        dLat = ToRad.call(lat2-lat1)
        dLon = ToRad.call(lon2-lon1)
        
        lat1 = ToRad.call(lat1)
        lat2 = ToRad.call(lat2)
        lon1 = ToRad.call(lon1)
        lon2 = ToRad.call(lon2)
        
        y = Math.sin(dLon) * Math.cos(lat2)
        x = Math.cos(lat1) * Math.sin(lat2) - Math.sin(lat1) * Math.cos(lat2) * Math.cos(dLon)
        return ToDegree.call( Math.atan2(y, x) )
        
      end      
      
    
      def constant_bearing_of_points(lat1, lat2, lon1, lon2)
        dLat = ToRad.call(lat2-lat1)
        dLon = ToRad.call(lon2-lon1)
        
        lat1 = ToRad.call(lat1)
        lat2 = ToRad.call(lat2)
        lon1 = ToRad.call(lon1)
        lon2 = ToRad.call(lon2)

        dPhi = Math.log( Math.tan(lat2/2 + Math::PI/4 ) / tan( lat1/2 + Math::PI/4 ) );
        
        begin
          q = dLat/dPhi
        rescue
          q = Math.cos(lat1)
        end
        
        if (dLon.abs > Math::PI)
          dLon = dLon > 0 ? -(2*Math::PI-dLon) : (2* Math::PI+dLon)
        end
        d = Math.sqrt(dLat*dLat + q*q*dLon*dLon) * Geocoder::Calculations::EARTH_RADIUS
        return ToDegree.call( Math.atan2(dLon, dPhi) )
        
      end
            
      def get_point_after_moving( bearing, starting_point, distance_travelled)
        
        lat1 = ToRad.call( starting_point.latitude.to_f )
        lon1 = ToRad.call( starting_point.longitude.to_f )
        
        angular_distance = ToRad.call( distance_travelled / Geocoder::Calculations::EARTH_RADIUS)
        
        
        lat3 = ToDegree.call( asin(sin(lat1)*cos( angular_distance ) + cos(lat1)*sin( angular_distance )*cos(bearing)) )
        lon3 = ToDegree.call(lon1 )+ atan2( cos( angular_distance ) - sin(lat1) * sin(lat3) , sin(bearing) * sin( angular_distance ) * cos(lat1) )
        
        #raise atan2( cos( angular_distance ) - sin(lat1) * sin(lat3) , sin(bearing) * sin( angular_distance ) * cos(lat1) ).inspect
        
        return [lat3, lon3]
      end
      
      def get_constant_movement_point( bearing, starting_point, distance_travelled )
        
        d = distance_travelled
        
        lat1 = ToRad.call( starting_point.latitude.to_f )
        lon1 = ToRad.call( starting_point.longitude.to_f )
              
        dLat = d*Math.cos(bearing)
        lat2 = ToRad.call( lat1 + dLat )
        raise [lat1, lat2].inspect

        dPhi = Math.log( Math.tan( lat2/2 + Math::PI/4 ) / Math.tan( lat1/2 + Math::PI/4 ) )
        
        begin
          q = dLat/dPhi
        rescue
          q = Math.cos(lat1)
        end

        dLon = d*Math.sin(bearing)/q
        if (Math.abs(lat2) > Math::PI/2) 
            lat2 = lat2 > 0 ? Math::PI-lat2 : -( Math::PI-lat2 )
        end
        lon2 = ( lon1 + dLon + Math::PI) % ( 2 * Math::PI ) - Math.PI # <--- WTF is This?
        raise [lat2, lon2].inspect
        ##### TO FINISH
        ##### TO FINISH
        ##### TO FINISH
                
      end
      

      bearing = constant_bearing_of_points(lat1, lat2, lon1, lon2)

      #get_constant_movement_point( bearing, starting_point, distance_travelled )
      
      result[:moving_done] = get_point_after_moving( bearing, starting_point, distance_travelled )
      
      return result
      #lat2 = 
      #lon2 = lon1 + atan2(sin(bearing)*sin(angular_distance)*cos(lat1), cos(angular_distance)−sin(lat1)*sin(lat2))
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