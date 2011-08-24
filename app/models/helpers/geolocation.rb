module Helpers
  class Geolocation
    
   attr_reader :from, :to, :result
   
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
         
   end
   
   def initialize( starting_point, ending_point, distance, options = {} )
     @from = LatLng.new( starting_point.latitude, starting_point.longitude )
     @to = LatLng.new( ending_point.latitude, ending_point.longitude )
     @distance = distance.to_f
     
     @unit = options[:units] || :kms
     @formula = options[:formula] || :sphere
     
     p distance_between();
   end
   
   
   def move()
     radius = case @unit
       when :kms; EARTH_RADIUS_IN_KMS
       when :nms; EARTH_RADIUS_IN_NMS
       else EARTH_RADIUS_IN_MILES
     end
     start = @from
     lat = deg2rad( start.lat )
     lng = deg2rad( start.lng )
     heading = deg2rad( heading_between() )
     
     end_lat = Math.asin( Math.sin(lat) * Math.cos(@distance/radius) + Math.cos(lat) * Math.sin(@distance/radius) * Math.cos(heading) )

     end_lng = lng + Math.atan2( Math.sin(heading) * Math.sin(@distance/radius) * Math.cos(lat), Math.cos(@distance/radius) - Math.sin(lat) * Math.sin(end_lat) )

     @result = LatLng.new( rad2deg(end_lat), rad2deg(end_lng) )
   end
    
   def to_json
     ActiveSupport::JSON.encode( { start_point: @from.to_a, end_point: @to.to_a, result: @result.to_a } )
   end
   
   protected
   
   def heading_between()
     d_lng = deg2rad( @to.lng - @from.lng )
     from_lat = deg2rad( @from.lat )
     to_lat = deg2rad( @to.lat )
     y = Math.sin(d_lng) * Math.cos(to_lat)
     x = Math.cos(from_lat) * Math.sin(to_lat) - Math.sin(from_lat) * Math.cos(to_lat) * Math.cos(d_lng)
     heading = to_heading( Math.atan2(y,x) )
   end
   
   def distance_between()
     return 0.0 if @from == @to # fixes a "zero-distance" bug
     case @formula
     when :sphere
       begin
         units_sphere_multiplier() *
             Math.acos( Math.sin( deg2rad( @from.lat ) ) * Math.sin( deg2rad( @to.lat ) ) +
             Math.cos( deg2rad( @from.lat ) ) * Math.cos( deg2rad( @to.lat ) ) *
             Math.cos( deg2rad( @to.lng ) - deg2rad( @from.lng ) ) )
       rescue Errno::EDOM
         0.0
       end
     when :flat
       Math.sqrt( ( units_per_latitude_degree() * ( @from.lat - @to.lat ) )**2 + ( units_per_longitude_degree( @from.lat ) * ( @from.lng - @to.lng ) )**2 )
     end
   end
   
   def deg2rad(degrees)
     degrees.to_f / 180.0 * Math::PI
   end
  
   def rad2deg(rad)
     rad.to_f * 180.0 / Math::PI
   end
   
   def to_heading(rad)
     (rad2deg(rad)+360)%360
   end
   
     def units_sphere_multiplier()
       case @unit
         when :kms; EARTH_RADIUS_IN_KMS
         when :nms; EARTH_RADIUS_IN_NMS
         else EARTH_RADIUS_IN_MILES
       end
     end

     # Returns the number of units per latitude degree.
     def units_per_latitude_degree()
       case @unit
         when :kms; KMS_PER_LATITUDE_DEGREE
         when :nms; NMS_PER_LATITUDE_DEGREE
         else MILES_PER_LATITUDE_DEGREE
       end
     end
   
     # Returns the number units per longitude degree.
     def units_per_longitude_degree(lat)
       miles_per_longitude_degree = (LATITUDE_DEGREES * Math.cos(lat * PI_DIV_RAD)).abs
       case @unit
         when :kms; miles_per_longitude_degree * KMS_PER_MILE
         when :nms; miles_per_longitude_degree * NMS_PER_MILE
         else miles_per_longitude_degree
       end
     end          
          
  end
end