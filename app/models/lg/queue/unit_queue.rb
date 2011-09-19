module LG
  module Queue
    class UnitQueue
      include Modules::Queue
      DB_CLASS = DB::Queue::Unit
      
      attr_reader :items
      
      def initialize
        @items = {}
      end
      
      def active_elements
        DB::Unit::Definition::UNIT_TYPES.map do |type|
          @items[type].select{|x| x.active? }.first
        end
      end
      
      #Ovverride Items...
      def items=( db_entries_array )
         raise ArgumentError, "Need an array of #{self.class::DB_CLASS}. Got #{db_entries_array.map{|x| x.class}.uniq.inspect}" if db_entries_array != [] && db_entries_array.map{|x| x.class}.uniq != [self.class::DB_CLASS]
         DB::Unit::Definition::UNIT_TYPES.each do |type|
           @items[type] = db_entries_array.select{|x| x.unit_type = type}
         end
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
                                 :unit_type => object.unit_type,
                                 :number => level_or_number,
                                 :time_needed => LG::Unit.production_time( object, production_building_level)
             
             #if @items.empty? #first item in queue!
             if DB_CLASS.find(:all, conditions: 
                                           { 
                                             city_id: queue_datas[:city_id], 
                                             player_id: queue_datas[:player_id], 
                                             unit_type: object.unit_type,
                                             finished: false 
                                           }
                             ).count <= 1
               a.start
               started = true
             else
               started = false
             end
             
             @items[object.unit_type].push(a)
             
             city_object.remove_resources( cost ) #Pay The Price
             return_values[:action] = { message: "Training #{level_or_number} #{object.name}", started: started }
          end
        else
          return_values[:errors].push( { message: "Not Enough Money", city_id: city_object.city_id } )
        end
        return return_values
      end
      
      def destroy( city_object, object, level_or_number )
        #TODO -> Implement
        
        #TODO -> Remove Item From Queue & DB
        #TODO -> Add Back to city enought money BASED ON THE NUMBER OF SOLDIERS NOT CREATED!
        
        return true
      end
      
    end
  end
end