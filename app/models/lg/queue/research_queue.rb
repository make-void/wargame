module LG
  module Queue
    class ResearchQueue
      include Modules::Queue
      DB_CLASS = DB::Queue::Tech
      
      attr_reader :items

      
      def add_item(city_object, object, level_or_number)    
          raise ArgumentError, "Need City to be a DB::City, Got #{city_object.inspect}" unless city_object.is_a?( DB::City )
          raise ArgumentError, "Need a #{DB::Research::Definition}" unless object.is_a?( DB::Research::Definition ) 
          cost = LG::Research.cost(object, level_or_number)

          return_values = { cost: cost, errors: [], action: nil }
          if self.city_hash_money?(city_object, cost) #defined in Queue module

            reqs = check_requisites( city_object, object )

            if reqs.is_a?(Array) #Requirements Are Met?
               return_values[:errors] = return_values[:errors] + reqs
            else
              
               res_obj = DB::Research::Upgrade.find(:first, :conditions => {
                                                            :tech_id => object.tech_id,
                                                            :player_id => city_object.player_id
                                                        })

               if res_obj.nil? #Create Research Object if Needed for DB Integrity
                 DB::Research::Upgrade.create( 
                                                  :tech_id => object.tech_id, 
                                                  :player_id => city_object.player_id,
                                                  :level => 0
                                                )
               end
               
               #Get Research Centre Level
               research_centre = DB::Structure::Definition.research_production_building_level(city_object.player_id, city_object.city_id)
               research_centre_level = research_centre.nil? ? 0 : research_centre.level 
               
               a = DB_CLASS.create :tech_id => object.tech_id,
                                   :city_id => city_object.city_id,
                                   :player_id => city_object.player_id,
                                   :level => level_or_number,
                                   :time_needed => LG::Research.time( 
                                                                        object, 
                                                                        level_or_number, 
                                                                        research_centre_level
                                                                      )

               if @items.empty? #first item in queue!
                 a.start( research_centre_level )
                 started = true
               else
                 started = false
               end

               @items.push(a)

               city_object.remove_resources( cost ) #Pay the Price!
               return_values[:action] = { message: "Researching #{level_or_number} #{object.name}", started: started }
            end
          else
            return_values[:errors].push( { message: "Not Enough Money", city_id: city_object.city_id } )
          end
          return return_values      
        end
      
    end
  end
end