module DefaultValues

  PTS_FILTER = 6000 # cities with population > 6000 (6132 cities)
  
  # utils - TODO: move in another class/module
  
  # require "#{Rails.root}/db/default_values"
  # include DefaultValues
  # drop_all_foreigns DB::Research::Requirements::Tech
  
  # def drop_all_foreigns(model)
  #   table_name = model.table_name
  #   cmd = ActiveRecord::Base.connection.execute("SHOW CREATE TABLE #{table_name}").to_a[0][1]
  #   foreigns = cmd.scan(/FOREIGN KEY \(`((\w|_)+)`\)/)
  #   foreigns.map do |foreign|
  #     foreign = foreign.first
  #     drop_foreign table_name, foreign
  #   end
  # end
  # 
  # def drop_foreign(table, key)
  #   puts "dropping foreign key '#{key}' from '#{table}'" 
  #   execute_query "ALTER TABLE #{table} DROP FOREIGN KEY #{key}"
  # end
  
  def execute_query(query)
    ActiveRecord::Base.connection.execute query
  end
  
  def recreate_db_structure # testing purposes
    queries = eval(File.read "#{Rails.root}/db/recreate_tables.rb")
    queries.each do |cmd|
      execute_query cmd
    end
  end

  
  # ----
  
  
  def create_default_vals
    
    ally = DB::Alliance.create! name: "No Alliance"


    DB::Player.create! name: "Free Lands", 
                  new_password: "NULLABLE", 
                  new_password_confirmation: "NULLABLE", 
                  email: "test@test.test", 
                  alliance_id: ally.id

   
    
    #################
    #     UNITS     #
    #################          
    DB::Unit::Definition.create! name: "Soldier",
                  unit_type: "Infantry",
                  attack_type: 0, 
                  power: 1,
                  defense: 1,
                  movement_speed: 4,
                  movement_cost: 0,
                  cargo_capacity: 20,
                  transport_capacity: 0,
                  gold_cost: 40,
                  steel_cost: 40,
                  oil_cost: 0

     DB::Unit::Definition.create! name: "Special Forces",
                   unit_type: "Infantry",
                   attack_type: 0,
                   power: 5,
                   defense: 3,
                   movement_speed: 4,
                   movement_cost: 0,
                   cargo_capacity: 20,
                   transport_capacity: 0,
                   gold_cost: 120,
                   steel_cost: 120,
                   oil_cost: 0

     DB::Unit::Definition.create! name: "Granatier",
                  unit_type: "Infantry",
                  attack_type: 1,
                  power: 15,
                  defense: 1,
                  movement_speed: 3,
                  movement_cost: 0,
                  cargo_capacity: 10,
                  transport_capacity: 0,
                  gold_cost: 150,
                  steel_cost: 120,
                  oil_cost: 0

     DB::Unit::Definition.create! name: "Jeep",
                  unit_type: "Vehicle",
                  attack_type: 2,
                  power: 40,
                  defense: 10,
                  movement_speed: 120,
                  movement_cost: 40,
                  cargo_capacity: 200,
                  transport_capacity: 10  ,
                  gold_cost: 250,
                  steel_cost: 200,
                  oil_cost: 80       

     DB::Unit::Definition.create! name: "Light Transport",
                  unit_type: "Vehicle",
                  attack_type: 0,
                  power: 0,
                  defense: 20,
                  movement_speed: 80,
                  movement_cost: 10,
                  cargo_capacity: 2000,
                  transport_capacity: 50,
                  gold_cost: 200,
                  steel_cost: 200,
                  oil_cost: 100

     DB::Unit::Definition.create! name: "Light Tank",
                  unit_type: "Vehicle",
                  attack_type: 0,
                  power: 60,
                  defense: 20,
                  movement_speed: 80,
                  movement_cost: 40,
                  cargo_capacity: 100,
                  transport_capacity: 5,
                  gold_cost: 350,
                  steel_cost: 500,
                  oil_cost: 250 

     DB::Unit::Definition.create! name: "Heavy Transport",
                  unit_type: "Vehicle",
                  attack_type: 0,
                  power: 0,
                  defense: 35,
                  movement_speed: 60,
                  movement_cost: 15,
                  cargo_capacity: 10000,
                  transport_capacity: 100,
                  gold_cost: 400,
                  steel_cost: 450,
                  oil_cost: 220


     DB::Unit::Definition.create! name: "Heavy Tank",
                  unit_type: "Vehicle",
                  attack_type: 0,
                  power: 140,
                  defense: 40,
                  movement_speed: 40,
                  movement_cost: 80,
                  cargo_capacity: 150,
                  transport_capacity: 5,
                  gold_cost: 800,
                  steel_cost: 850,
                  oil_cost: 250


     #################
     #  STRUCTURES   #
     #################
     DB::Structure::Definition.create! name: "Market", 
                 description: "Produces Gold",
                 gold_cost: 85,
                 steel_cost: 42,
                 oil_cost: 0,
                 cost_advancement_type: 0,
                 base_production: 45,
                 max_level: 25

     DB::Structure::Definition.create! name: "Foundry",
                 description: "Produces Steel",
                 gold_cost: 73,
                 steel_cost: 64,
                 oil_cost: 0,
                 cost_advancement_type: 0,
                 base_production: 35,
                 max_level: 25

     DB::Structure::Definition.create! name: "Refinery",
                 description: "Produces Oil",
                 gold_cost: 140,
                 steel_cost: 59,
                 oil_cost: 0,
                 cost_advancement_type: 0,
                 base_production: 15,
                 max_level: 25

     DB::Structure::Definition.create! name: "Bank",
                 description: "Storage Room for Gold",
                 gold_cost: 2000,
                 steel_cost: 1300,
                 oil_cost: 0,
                 cost_advancement_type: 1,
                 max_level: 10

     DB::Structure::Definition.create! name: "Warehouse",
                 description: "Storage Room for Steel and Oil",
                 gold_cost: 800,
                 steel_cost: 2000,
                 oil_cost: 500,
                 cost_advancement_type: 1,
                 max_level: 10

     DB::Structure::Definition.create! name: "Barracks",
                 description: "Produces Infantry Units",
                 gold_cost: 400,
                 steel_cost: 200,
                 oil_cost: 100,
                 cost_advancement_type: 2,
                 max_level: 15

     DB::Structure::Definition.create! name: "Factory",
                 description: "Produces Veicles",
                 gold_cost: 600,
                 steel_cost: 800,
                 oil_cost: 150,
                 cost_advancement_type: 2,
                 max_level: 15

     DB::Structure::Definition.create! name: "Research Center",
                 description: "Produces Researches",
                 gold_cost: 400,
                 steel_cost: 200,
                 oil_cost: 150,
                 cost_advancement_type: 2,
                 max_level: 15

     DB::Structure::Definition.create! name: "Bunker",
                 description: "Increases Defence if City is Attacked",
                 gold_cost: 5000,
                 steel_cost: 10000,
                 oil_cost: 1500,
                 cost_advancement_type: 2,
                 max_level: 10

     #################
     #  RESEARCHES   #
     #################
     DB::Research::Definition.create! name: "Infantry Weapon Upgrade",
                 description: "to-be-added",
                 gold_cost: 300,
                 steel_cost: 800,
                 oil_cost: 0,
                 max_level: 20

     DB::Research::Definition.create! name: "Infantry Armor Upgrade",
                 description: "to-be-added" ,
                 gold_cost: 250,
                 steel_cost: 1000,
                 oil_cost: 0,
                 max_level: 20

     DB::Research::Definition.create! name: "Vehicle Weapon Upgrade",
                 description: "to-be-added",
                 gold_cost: 500,
                 steel_cost: 1000,
                 oil_cost: 0,
                 max_level: 20

     DB::Research::Definition.create! name: "Vehicle Armor Upgrade",
                 description: "to-be-added",
                 gold_cost: 400,
                 steel_cost: 800,
                 oil_cost: 400,
                 max_level: 20

     DB::Research::Definition.create! name: "Construction Industry Techniques",
                 description: "to-be-added",
                 gold_cost: 1200,
                 steel_cost: 1500,
                 oil_cost: 1000,
                 max_level: 20

     DB::Research::Definition.create! name: "Espionage",
                 description: "to-be-added",
                 gold_cost: 900,
                 steel_cost: 600,
                 oil_cost: 200,
                 max_level: 20

     DB::Research::Definition.create! name: "Engine Power",
                 description: "to-be-added",
                 gold_cost: 1000,
                 steel_cost: 1500,
                 oil_cost: 1200,
                 max_level: 10
                 
                 
                 
      ##########################
      #  RESEARCH REQUIREMENTS #
      ##########################
     #Infantry Weapon => 1 Research Center
     DB::Research::Requirement::Building.create! :tech_id => 1, :req_structure_id => 8, :level => 1
     #Infantry Armor => 1 Research Center
     DB::Research::Requirement::Building.create! :tech_id => 2, :req_structure_id => 8, :level => 1
     #Vehicle Weapon => 2 Research Center
     DB::Research::Requirement::Building.create! :tech_id => 3, :req_structure_id => 8, :level => 2
     #Vehicle Armor => 2 Research Center
     DB::Research::Requirement::Building.create! :tech_id => 4, :req_structure_id => 8, :level => 2
     #Construction Industry Techniques => 10 Research Center
     DB::Research::Requirement::Building.create! :tech_id => 5, :req_structure_id => 8, :level => 10
     #Espionage => 1 Research Center
     DB::Research::Requirement::Building.create! :tech_id => 6, :req_structure_id => 8, :level => 4
     #Engine Power => 5 Research Center, 2 Factory
     DB::Research::Requirement::Building.create! :tech_id => 7, :req_structure_id => 7, :level => 2
     DB::Research::Requirement::Building.create! :tech_id => 7, :req_structure_id => 8, :level => 5

     ##########################
     # STRUCTURE REQUIREMENTS #
     ##########################
     
     #Bank => 3 Market
     DB::Structure::Requirement::Building.create! :structure_id => 4, :req_structure_id => 1, :level => 3
     #WareHouse => 3 Foundry, 3 Refinery
     DB::Structure::Requirement::Building.create! :structure_id => 5, :req_structure_id => 2, :level => 3
     DB::Structure::Requirement::Building.create! :structure_id => 5, :req_structure_id => 3, :level => 3
     #Bunker => 8 Barrak, 5 Factory
     DB::Structure::Requirement::Building.create! :structure_id => 9 , :req_structure_id => 6, :level => 8
     DB::Structure::Requirement::Building.create! :structure_id => 9 , :req_structure_id => 7, :level => 5
     
     #Barrak => 1 Infantry Weapon
     DB::Structure::Requirement::Tech.create! :structure_id => 6, :req_tech_id => 1, :level => 1
     #Factory => 2 Vehicle Weapon, 2 Vehicle Armor
     DB::Structure::Requirement::Tech.create! :structure_id => 7, :req_tech_id => 3, :level => 2
     DB::Structure::Requirement::Tech.create! :structure_id => 7, :req_tech_id => 4, :level => 2
     #Bunker => 6 Infantry Weapon, 5 Vehicle Armor
     DB::Structure::Requirement::Tech.create! :structure_id => 9, :req_tech_id => 1, :level => 6
     DB::Structure::Requirement::Tech.create! :structure_id => 9, :req_tech_id => 4, :level => 5
     
     
     ##########################
     #   UNITS REQUIREMENTS   #
     ##########################
     #Soldier => 1 Barrak
     DB::Unit::Requirement::Building.create! :unit_id => 1, :req_structure_id => 6, :level => 1
     #Special Forces => 4 Barrak
     DB::Unit::Requirement::Building.create! :unit_id => 2, :req_structure_id => 6, :level => 4
     #Granatier => 6 Barrak, 2 Factory
     DB::Unit::Requirement::Building.create! :unit_id => 3, :req_structure_id => 6, :level => 6
     DB::Unit::Requirement::Building.create! :unit_id => 3, :req_structure_id => 7, :level => 2
     #Jeep => 3 Factory
     DB::Unit::Requirement::Building.create! :unit_id => 4, :req_structure_id => 7, :level => 2
     #Light Transport => 5 Factory
     DB::Unit::Requirement::Building.create! :unit_id => 5, :req_structure_id => 7, :level => 6
     #Light Tank => 6 Factory
     DB::Unit::Requirement::Building.create! :unit_id => 6, :req_structure_id => 7, :level => 6
     #Heavy Transport => 8 Factory
     DB::Unit::Requirement::Building.create! :unit_id => 7, :req_structure_id => 7, :level => 8
     #Heavy Tank => 12 Factory
     DB::Unit::Requirement::Building.create! :unit_id => 8, :req_structure_id => 7, :level => 12
     
     #Soldier => 2 Infantry Weapon
     DB::Unit::Requirement::Tech.create! :unit_id => 1, :req_tech_id => 1, :level => 2
     #Special Forces => 4 Infantry Weapon, 4 Infantry Armor
     DB::Unit::Requirement::Tech.create! :unit_id => 2, :req_tech_id => 2, :level => 4
     DB::Unit::Requirement::Tech.create! :unit_id => 2, :req_tech_id => 3, :level => 4
     #Granatier => 6 Infantry Weapon, 6 Infantry Armor
     DB::Unit::Requirement::Tech.create! :unit_id => 3, :req_tech_id => 2, :level => 6
     DB::Unit::Requirement::Tech.create! :unit_id => 3, :req_tech_id => 3, :level => 6
     #Jeep => 1 Engine Power
     DB::Unit::Requirement::Tech.create! :unit_id => 4, :req_tech_id => 7, :level => 1
     #Light Transport => 5 Vehicle Armor, 3 Engine Power
     DB::Unit::Requirement::Tech.create! :unit_id => 5, :req_tech_id => 3, :level => 5
     DB::Unit::Requirement::Tech.create! :unit_id => 5, :req_tech_id => 7, :level => 3
     #Light Tank => 5 Vehicle Armor, 5 Vehicle Weapon
     DB::Unit::Requirement::Tech.create! :unit_id => 6, :req_tech_id => 3, :level => 5
     DB::Unit::Requirement::Tech.create! :unit_id => 6, :req_tech_id => 4, :level => 5
     #Heavy Transport => 5 Vehicle Armor, 3 Engine Power
     DB::Unit::Requirement::Tech.create! :unit_id => 7, :req_tech_id => 3, :level => 8
     DB::Unit::Requirement::Tech.create! :unit_id => 7, :req_tech_id => 7, :level => 6
     #Heavy Tank => 5 Vehicle Armor, 5 Vehicle Weapon
     DB::Unit::Requirement::Tech.create! :unit_id => 8, :req_tech_id => 3, :level => 8
     DB::Unit::Requirement::Tech.create! :unit_id => 8, :req_tech_id => 4, :level => 6
  end
  
end