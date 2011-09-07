module LG
  module Queue
    class UnitQueue
      include Modules::Queue
      DB_CLASS = DB::Queue::Unit
      
      attr_reader :items
      
      def add_item(city_object, object, level_or_number)    
        raise ArgumentError, "Need City to be a DB::City, Got #{city_object.inspect}" unless city_object.class == DB::City
        raise ArgumentError, "Need a #{DB::Unit::Definition}" unless object.is_a?( DB::Unit::Definition ) 
        cost = LG::Research.cost(object, level_or_number)
        
        return_values = { cost: cost, errors: [], action: nil }
        if self.city_hash_money?(city_object, cost) #defined in Queue module
          ##CHECK FOR REQUIREMENTS!!!!!!!!!!!
          
          #SEARCH FOR POSSIBLE ERRORS AND ADD THEM TO return_values[:errors]
          a = DB_CLASS.create :unit_id => object.unit_id,
                              :city_id => city_object.city_id,
                              :player_id => city_object.player_id,
                              :number => level_or_number
                                 
          #IF FIRST ITEM IN QUEUE START!
          if true #first item in queue!
            a.start!
            started = true
          else
            started = false
          end
          
          city_object.remove_resources( cost )
          return_values[:action] = { message: "Building #{level_or_number} #{object.name}", started: started }
        else
          return_values[:errors].push({message: "Not Enough Money", city_id: city_object.city_id})
          return return_values
        end
      end
      
    end
  end
end