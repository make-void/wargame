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
        # TODO: se faila deleta lo worker
        raise ArgumentError, "Need City to be a DB::City, Got #{city_object.inspect}" unless city_object.is_a?( DB::City )
        raise ArgumentError, "Need a #{DB::Structure::Definition}" unless object.is_a?( DB::Structure::Definition ) 
        cost = LG::Structures.cost(object, level_or_number)
        
        return_values = { cost: cost, errors: [], action: nil }
        if self.city_has_money?(city_object, cost) #defined in Queue Module
          reqs = check_requisites( city_object, object ) #defined in Queue Module
          
          if reqs.is_a?(Array)          #Requirements Are Met? (WTF??? why array?)
            return_values[:errors] = return_values[:errors] + reqs
          else
            build_obj = build_or_get_base_object( :structure_id => object.structure_id, 
                                                  :city_id => city_object.city_id, 
                                                  :player_id => city_object.player_id   )

            if ( build_obj.level + 1 ) != level_or_number #You told me to create lev 5, but i don't have lev 4!
              return_values[:errors].push(
                 {
                   message: "Cannot Build '#{object.name}' to level #{level_or_number}. Need it at level #{level_or_number - 1}, got it at level #{build_obj.level}",
                   city_id: city_object.city_id
                 }
              )
            else
              return_values.merge! do_add_item(object, city_object, level_or_number, cost)
            end
            
          end
        else
          return_values[:errors].push( { message: "Not Enough Money", city_id: city_object.city_id } )
        end
        
        return_values      
      end
      
      def destroy!( city_object, object, level_or_number )
        
        queue_entry = DB_CLASS.find(:first, conditions: {
          city_id: city_object.city_id,
          structure_id: object.structure_id,
          level: level_or_number,
          finished: false
        })
        
        unless queue_entry.nil? || queue_entry.finished?
          cost = LG::Structures.cost(object, level_or_number)
          city_object.add_resources cost #Add Back to city enought money
          queue_entry.destroy #Remove Item From DB
          
          #Remove Item from Items. We can be sure that structure (id 1 level 2) can be safely removed
          #because we cannot set in queue structure (id 1 level 2) && structure (id 1 level 3).
          #If we want to enable that, removing (id 1 level 2) should triggher removal of (id 1 level 3) first
          @items.reject!{|x| ( x.city_id == city_object.city_id ) && ( x.structure_id == object.structure_id ) }
          return true
        else
          return false
        end
        
      end
      
      private
      
      def do_add_item(object, city_object, level_or_number, cost)
        queue_datas = { :structure_id => object.structure_id, :city_id => city_object.city_id, :player_id => city_object.player_id }
        
        #Create Queue Object
        building_speed = DB::Research::Upgrade.find_building_speed_research(city_object.player_id)
        time_needed = LG::Structures.time( object, level_or_number, building_speed )
        queue_object = DB_CLASS.create queue_datas.merge(
                        :level => level_or_number,
                        :time_needed => time_needed
                       )                                        
        
        
        # if @items.empty? #first item in queue!
        if DB_CLASS.find(:all, conditions: 
                                      { 
                                        city_id: queue_datas[:city_id], 
                                        player_id: queue_datas[:player_id], 
                                        finished: false 
                                      }
                        ).count <= 1
          upgrade = DB::Research::Upgrade.find_building_speed_research city_object.player_id 
          queue_object.start upgrade
          started = true
        else
          started = false
        end
        
        @items.push queue_object if @items
        
        city_object.remove_resources cost #Pay the Price!

        { message: "Building #{level_or_number} #{object.name}", started: started, time_needed: time_needed } 
      end
      
      
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