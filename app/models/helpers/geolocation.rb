module Helpers
  module Geolocation
   
   PI_DIV_RAD = 0.0174
   KMS_PER_MILE = 1.609
   NMS_PER_MILE = 0.868976242
   EARTH_RADIUS_IN_MILES = 3963.19
   EARTH_RADIUS_IN_KMS = EARTH_RADIUS_IN_MILES * KMS_PER_MILE
   EARTH_RADIUS_IN_NMS = EARTH_RADIUS_IN_MILES * NMS_PER_MILE
   MILES_PER_LATITUDE_DEGREE = 69.1
   KMS_PER_LATITUDE_DEGREE = MILES_PER_LATITUDE_DEGREE * KMS_PER_MILE
   NMS_PER_LATITUDE_DEGREE = MILES_PER_LATITUDE_DEGREE * NMS_PER_MILE
   LATITUDE_DEGREES = EARTH_RADIUS_IN_MILES / MILES_PER_LATITUDE_DEGREE
   
   DEF_UNIT = :kms
   DEF_FORMULA = :sphere
   
   class LatLng
     attr_accessor :lat, :lng
     
     def initialize(lat=nil, lng=nil)
       lat = lat.to_f if lat
       lng = lng.to_f if lng
       @lat = lat
       @lng = lng
     end
     
     def lat=(lat) ; @lat = lat.to_f if lat ; end
     def lng=(lng) ; @lng=lng.to_f if lng ; end
     def to_a ; [lat,lng] ; end
     def to_s ; "#{lat},#{lng}" ; end
     def ==(other) ; other.is_a?(LatLng) ? self.lat == other.lat && self.lng == other.lng : false; end
     def hash ; lat.hash + lng.hash ; end
     def eql?(other) ; self == other ; end
     def latitude ; @lat ; end
     def longitude ; @lon ; end
         
   end

 
   def self.move( from, to, distance, unit = DEF_UNIT)
     from = LatLng.new( from.latitude, from.longitude ) unless from.class == LatLng
     to = LatLng.new( to.latitude, to.longitude ) unless to.class == LatLng

     radius = case unit
       when :kms; EARTH_RADIUS_IN_KMS
       when :nms; EARTH_RADIUS_IN_NMS
       else EARTH_RADIUS_IN_MILES
     end
     start = from
     lat = Geolocation.deg2rad( start.lat )
     lng = Geolocation.deg2rad( start.lng )
     heading = Geolocation.deg2rad( Geolocation.heading_between( from, to) )
     
     end_lat = Math.asin( Math.sin(lat) * Math.cos(distance/radius) + Math.cos(lat) * Math.sin(distance/radius) * Math.cos(heading) )

     end_lng = lng + Math.atan2( Math.sin(heading) * Math.sin(distance/radius) * Math.cos(lat), Math.cos(distance/radius) - Math.sin(lat) * Math.sin(end_lat) )

     destination_value = LatLng.new( Geolocation.rad2deg(end_lat), Geolocation.rad2deg(end_lng) )
     
     return  { moving_from: from.to_a, moving_to: to.to_a, reached: destination_value.to_a, estimated_time: ( Geolocation.distance_between(from, to) / distance.to_f ) }
   end
   
   protected

   def self.heading_between( from, to )
     from = LatLng.new( from.latitude, from.longitude ) unless from.class == LatLng
     to = LatLng.new( to.latitude, to.longitude ) unless to.class == LatLng
     
     d_lng = Geolocation.deg2rad( to.lng - from.lng )
     from_lat = Geolocation.deg2rad( from.lat )
     to_lat = Geolocation.deg2rad( to.lat )
     y = Math.sin(d_lng) * Math.cos(to_lat)
     x = Math.cos(from_lat) * Math.sin(to_lat) - Math.sin(from_lat) * Math.cos(to_lat) * Math.cos(d_lng)
     heading = Geolocation.to_heading( Math.atan2(y,x) )
   end
   
   def self.distance_between( from, to, formula = DEF_FORMULA)
     from = LatLng.new( from.latitude, from.longitude ) unless from.class == LatLng
     to = LatLng.new( to.latitude, to.longitude ) unless to.class == LatLng
     
     return 0.0 if from == to # fixes a "zero-distance" bug
     case formula
     when :sphere
       begin
         units_sphere_multiplier() *
             Math.acos( Math.sin( deg2rad( from.lat ) ) * Math.sin( Geolocation.deg2rad( to.lat ) ) +
             Math.cos( Geolocation.deg2rad( from.lat ) ) * Math.cos( Geolocation.deg2rad( to.lat ) ) *
             Math.cos( Geolocation.deg2rad( to.lng ) - Geolocation.deg2rad( from.lng ) ) )
       rescue Errno::EDOM
         0.0
       end
     when :flat
       Math.sqrt( ( Geolocation.units_per_latitude_degree() * ( from.lat - to.lat ) )**2 + ( Geolocation.units_per_longitude_degree( from.lat ) * ( from.lng - to.lng ) )**2 )
     end
   end
   
   def self.deg2rad(degrees)
     degrees.to_f / 180.0 * Math::PI
   end
  
   def self.rad2deg(rad)
     rad.to_f * 180.0 / Math::PI
   end
   
   def self.to_heading(rad)
     (Geolocation.rad2deg(rad)+360)%360
   end
   
   def self.units_sphere_multiplier(unit = DEF_UNIT)
     case unit
       when :kms; EARTH_RADIUS_IN_KMS
       when :nms; EARTH_RADIUS_IN_NMS
       else EARTH_RADIUS_IN_MILES
     end
   end
   
   # Returns the number of units per latitude degree.
   def self.units_per_latitude_degree(unit = DEF_UNIT)
     case unit
       when :kms; KMS_PER_LATITUDE_DEGREE
       when :nms; NMS_PER_LATITUDE_DEGREE
       else MILES_PER_LATITUDE_DEGREE
     end
   end
   
   # Returns the number units per longitude degree.
   def self.units_per_longitude_degree(lat, unit = DEF_UNIT)
     miles_per_longitude_degree = (LATITUDE_DEGREES * Math.cos(lat * PI_DIV_RAD)).abs
     case unit
       when :kms; miles_per_longitude_degree * KMS_PER_MILE
       when :nms; miles_per_longitude_degree * NMS_PER_MILE
       else miles_per_longitude_degree
     end
   end          
          
  end
end