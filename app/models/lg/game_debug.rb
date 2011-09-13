module LG
  module GameDebug
    
    ###################################
    #      BUILDING DEBUG PUTS        #
    ###################################

      def debug_buildings
        LG::Game.get_all_base_infos()[:structures].each_with_index do |y, x|
          puts "#{x}: #{y[:name]}"
          puts "    - #{y[:description]}"
          puts "    - Cost: gold #{y[:cost][:gold]}, steel #{y[:cost][:steel]}, oil #{y[:cost][:oil]}, time(seconds) #{y[:cost][:base_time]}"
          puts "    - Max Level: #{y[:max_level]}"
          puts "    - Requirements: (Researches)"
          y[:requirements][:researches].map do |res_req|
            puts "        - #{DB::Research::Definition.find(res_req[:tech_id]).name}: #{res_req[:level]}"
          end
          puts "    - Requirements: (Buildings)"
          y[:requirements][:buildings].map do |build_req|
            puts "        - #{DB::Structure::Definition.find(build_req[:structure_id]).name}: #{build_req[:level]}"
          end
          puts "    - BASE PRODUCTION: #{y[:base_production]}" if y[:base_production]

        end
        return nil
      end

    ###################################
    #         UNITS DEBUG PUTS        #
    ###################################

        def debug_units
          LG::Game.get_all_base_infos()[:units].each_with_index do |y, x|
            puts "#{x}: #{y[:name]} (#{y[:stats][:power]}/#{y[:stats][:defense]})"
            puts "    - AttackType: #{y[:attack_type]}"
            puts "    - Movement: Speed #{y[:stats][:movement_speed]}, Cost #{y[:stats][:movement_cost]}"
            puts "    - Transport: Units #{y[:stats][:transport_capacity]}, Resources #{y[:stats][:cargo_capacity]}"
            puts "    - Cost: gold #{y[:cost][:gold]}, steel #{y[:cost][:steel]}, oil #{y[:cost][:oil]}, time(seconds) #{y[:cost][:base_time]}"
            puts "    - Requirements: (Research)"
            y[:requirements][:researches].map do |res_req|
              puts "        - #{DB::Research::Definition.find(res_req[:tech_id]).name}: #{res_req[:level]}"
            end
            puts "    - Requirements: (Buildings)"
            y[:requirements][:buildings].map do |build_req|
              puts "        - #{DB::Structure::Definition.find(build_req[:structure_id]).name}: #{build_req[:level]}"
            end
          end
          return nil
        end

    ###################################
    #      RESEARCHES DEBUG PUTS      #
    ###################################

      def debug_researches
        LG::Game.get_all_base_infos()[:researches].each_with_index do |y, x|
          puts "#{x}: #{y[:name]}"
          puts "    - #{y[:description]}"
          puts "    - Cost: gold #{y[:cost][:gold]}, steel #{y[:cost][:steel]}, oil #{y[:cost][:oil]}, time(seconds) #{y[:cost][:base_time]}"
          puts "    - Max Level: #{y[:max_level]}"
          puts "    - Requirements: (Researches)"
          y[:requirements][:researches].map do |res_req|
            puts "        - #{DB::Research::Definition.find(res_req[:tech_id]).name}: #{res_req[:level]}"
          end
          puts "    - Requirements: (Buildings)"
          y[:requirements][:buildings].map do |build_req|
            puts "        - #{DB::Structure::Definition.find(build_req[:structure_id]).name}: #{build_req[:level]}"
          end

        end
        return nil
     end
   
  end
end