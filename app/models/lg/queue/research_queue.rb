module LG
  module Queue
    class ResearchQueue
      include Modules::Queue
      DB_CLASS = DB::Queue::Tech
      
      attr_reader :items

      def active_element
        return @items.select{|x| x.active? }.first
      end
      
      def add_item(city_object, object, level_or_number)    
          raise ArgumentError, "Need City to be a DB::City, Got #{city_object.inspect}" unless city_object.is_a?( DB::City )
          raise ArgumentError, "Need a #{DB::Research::Definition}" unless object.is_a?( DB::Research::Definition ) 
          cost = LG::Research.cost(object, level_or_number)

          return_values = { cost: cost, errors: [], action: nil }
          if self.city_has_money?(city_object, cost) #defined in Queue Module

            reqs = check_requisites( city_object, object ) #defined in Queue Module

            if reqs.is_a?(Array) #Requirements Are Met?
               return_values[:errors] = return_values[:errors] + reqs
            else
               res_obj = build_or_get_base_object( 
                                                    :tech_id => object.tech_id, 
                                                    :player_id => city_object.player_id
                                                  )
                                                  
               if ( res_obj.level + 1 ) != level_or_number #You told me to create lev 5, but i don't have lev 4!
                 return_values[:errors].push(
                    {
                      message: "Cannot Research '#{object.name}' to level #{level_or_number}. Need it at level #{level_or_number - 1}, got it at level #{res_obj.level}",
                      city_id: city_object.city_id
                    }
                 )
                 return return_values #Stop it here
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

               #if @items.empty? #first item in queue!
               if DB_CLASS.find(:all, conditions: 
                                             { 
                                               city_id: city_object.city_id, 
                                               player_id: city_object.player_id, 
                                               finished: false 
                                             }
                               ).count <= 1
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
        
        def destroy!( city_object, object, level_or_number )
          queue_entry = DB_CLASS.find(:first, conditions: {
            city_id: city_object.city_id,
            tech_id: object.tech_id,
            level: level_or_number,
            finished: false
          })

          unless queue_entry.nil? || queue_entry.finished?
            cost = LG::Research.cost(object, level_or_number)
            city_object.add_resources cost #Add Back to city enought money
            queue_entry.destroy #Remove Item From DB

            #Remove Item from Items. We can be sure that tech (id 1 level 2) can be safely removed
            #because we cannot set in queue tech (id 1 level 2) && tech (id 1 level 3).
            #If we want to enable that, removing (id 1 level 2) should triggher removal of (id 1 level 3) first
            @items.reject!{|x| ( x.city_id == city_object.city_id ) && ( x.tech_id == object.tech_id ) }
            return true
          else
            return false
          end
        end
        
        private
        
        def build_or_get_base_object( hash_values )
          obj = get_base_object( hash_values )
          return obj if !obj.nil?
          return build_base_object( hash_values )
          
        end
        def get_base_object( hash_values )
          return DB::Research::Upgrade.find(:first, :conditions => hash_values )
        end
        def build_base_object( hash_values )
          return DB::Research::Upgrade.create( hash_values.merge({:level => 0}))
        end
      
    end
  end
end