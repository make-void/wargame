module LG
  module Queue
    class BuildingQueue
      DB_CLASS = DB::Queue::Building
      include Modules::Queue
      
      attr_reader :items
      
      def active_element
        return @items.select{|x| x.active? }.first
      end
      
      def add_item(city_object, object, level_or_number)    
        raise ArgumentError, "Need City to be a DB::City, Got #{city_object.inspect}" unless city_object.is_a?( DB::City )
        raise ArgumentError, "Need a #{DB::Structure::Definition}" unless object.is_a?( DB::Structure::Definition ) 
        cost = LG::Structures.cost(object, level_or_number)
        
        return_values = { cost: cost, errors: [], action: nil }
        if self.city_hash_money?(city_object, cost) #defined in Queue Module
          reqs = check_requisites( city_object, object ) #defined in Queue Module
          
          if reqs.is_a?(Array)          #Requirements Are Met?
             return_values[:errors] = return_values[:errors] + reqs
          else
            
            build_obj = build_or_get_base_object( 
                                                  :structure_id => object.structure_id, 
                                                  :city_id => city_object.city_id, 
                                                  :player_id => city_object.player_id
                                                )
                                                             
            if ( build_obj.level + 1 ) != level_or_number #You told me to create lev 5, but i don't have lev 4!
              return_values[:errors].push(
                 {
                   message: "Cannot Build '#{object.name}' to level #{level_or_number}. Need it at level #{level_or_number - 1}, got it at level #{build_obj.level}",
                   city_id: city_object.city_id
                 }
              )
              return return_values #Stop it here
            end
            
            #Create Queue Object
            a = DB_CLASS.create :structure_id => object.structure_id,
                                :city_id => city_object.city_id,
                                :player_id => city_object.player_id,
                                :level => level_or_number,
                                :time_needed => LG::Structures.time( 
                                                                     object, 
                                                                     level_or_number, 
                                                                     DB::Research::Upgrade.find_building_speed_research(city_object.player_id) 
                                                                   )
            if @items.nil? || @items.empty? #first item in queue!
              a.start( DB::Research::Upgrade.find_building_speed_research(city_object.player_id) )
              started = true
            else
              started = false
            end
            
            @items.push(a)
            
            city_object.remove_resources( cost ) #Pay the Price!
            return_values[:action] = { message: "Building #{level_or_number} #{object.name}", started: started }
          end
        else
          return_values[:errors].push( { message: "Not Enough Money", city_id: city_object.city_id } )
        end
        return return_values      
      end
      
      private
      
      def build_or_get_base_object(hash_values)
        obj = get_base_object( hash_values )
        return obj if !obj.nil?
        return build_base_object( hash_values )
      end
      def get_base_object( hash_values )
        return DB::Structure::Building.find(:first, :conditions => hash_values )
      end
      def build_base_object( hash_values )
        return DB::Structure::Building.create(  hash_values.merge({:level => 0}) )
      end
      
      
    end
  end
end