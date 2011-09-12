module LG
  module Queue
    class UnitQueue
      include Modules::Queue
      DB_CLASS = DB::Queue::Unit
      
      attr_reader :items
      
      def active_element
        return @items.select{|x| x.active? }.first
      end
      
      def add_item(city_object, object, level_or_number)    
        raise ArgumentError, "Need City to be a DB::City, Got #{city_object.inspect}" unless city_object.is_a?( DB::City )
        raise ArgumentError, "Need a #{DB::Unit::Definition}" unless object.is_a?( DB::Unit::Definition ) 
        cost = LG::Unit.cost(object, level_or_number)
        
        return_values = { cost: cost, errors: [], action: nil }
        if self.city_has_money?(city_object, cost) #defined in Queue Module
          
          reqs = check_requisites( city_object, object ) #defined in Queue Module
          
          if reqs.is_a?(Array) #Requirements Are Met?
             return_values[:errors] = return_values[:errors] + reqs
          else
            
             #Get Production Building Level
             production_building_id = DB::Unit::Definition::PRODUCTION_CENTRE_ID[object.unit_type]
             production_building = DB::Structure::Building.find(:first,:conditions =>{
                                                                                        :city_id => city_object.city_id,
                                                                                        :player_id => city_object.player_id,
                                                                                        :structure_id => production_building_id
                                                                                     }
                                                               )
                                                               
             production_building_level = production_building.nil? ? 0 : production_building.level
             
             a = DB_CLASS.create :unit_id => object.unit_id,
                                 :city_id => city_object.city_id,
                                 :player_id => city_object.player_id,
                                 :number => level_or_number,
                                 :time_needed => LG::Unit.production_time( object, production_building_level)
             
             if @items.empty? #first item in queue!
               a.start
               started = true
             else
               started = false
             end
             
             @items.push(a)
             
             city_object.remove_resources( cost ) #Pay The Price
             return_values[:action] = { message: "Training #{level_or_number} #{object.name}", started: started }
          end
        else
          return_values[:errors].push( { message: "Not Enough Money", city_id: city_object.city_id } )
        end
        return return_values
      end
      
    end
  end
end