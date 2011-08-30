module DefaultValues

  PTS_FILTER = 6000 # cities with population > 6000 (6132 cities)
  
  def create_default_vals

    DB::Alliance.create name: "No Alliance"

    DB::Player.create name: "Free Lands", 
                  new_password: "NULLABLE", 
                  new_password_confirmation: "NULLABLE", 
                  email: "test@test.test", 
                  alliance_id: 1
                  
    DB::Player.create name: "Cor3y", 
                  new_password: "daniel001", 
                  new_password_confirmation: "daniel001", 
                  email: "test1@test.test", 
                  alliance_id: 1
                  
    DB::Player.create name: "Makevoid", 
                  new_password: "final33man", 
                  new_password_confirmation: "final33man", 
                  email: "test2@test.test", 
                  alliance_id: 1
    
    #################
    #     UNITS     #
    #################          
    DB::Unit::Definition.create name: "Soldier",
                  unit_type: "Infantry",
                  attack_type: 0, 
                  power: 1,
                  defence: 1,
                  movement_speed: 4,
                  movement_cost: 0,
                  cargo_capacity: 20,
                  transport_capacity: 0,
                  gold_cost: 40,
                  steel_cost: 40,
                  oil_cost: 0

     DB::Unit::Definition.create name: "Special Forces",
                   unit_type: "Infantry",
                   attack_type: 0,
                   power: 5,
                   defence: 3,
                   movement_speed: 4,
                   movement_cost: 0,
                   cargo_capacity: 20,
                   transport_capacity: 0,
                   gold_cost: 120,
                   steel_cost: 120,
                   oil_cost: 0

     DB::Unit::Definition.create name: "Granatier",
                  unit_type: "Infantry",
                  attack_type: 1,
                  power: 15,
                  defence: 1,
                  movement_speed: 3,
                  movement_cost: 0,
                  cargo_capacity: 10,
                  transport_capacity: 0,
                  gold_cost: 150,
                  steel_cost: 120,
                  oil_cost: 0

     DB::Unit::Definition.create name: "Jeep",
                  unit_type: "Vehicle",
                  attack_type: 2,
                  power: 40,
                  defence: 10,
                  movement_speed: 120,
                  movement_cost: 40,
                  cargo_capacity: 200,
                  transport_capacity: 10  ,
                  gold_cost: 250,
                  steel_cost: 200,
                  oil_cost: 80       

     DB::Unit::Definition.create name: "Light Transport",
                  unit_type: "Vehicle",
                  attack_type: 0,
                  power: 0,
                  defence: 20,
                  movement_speed: 80,
                  movement_cost: 10,
                  cargo_capacity: 2000,
                  transport_capacity: 50,
                  gold_cost: 200,
                  steel_cost: 200,
                  oil_cost: 100

     DB::Unit::Definition.create name: "Light Tank",
                  unit_type: "Vehicle",
                  attack_type: 0,
                  power: 60,
                  defence: 20,
                  movement_speed: 80,
                  movement_cost: 40,
                  cargo_capacity: 100,
                  transport_capacity: 5,
                  gold_cost: 350,
                  steel_cost: 500,
                  oil_cost: 250 

     DB::Unit::Definition.create name: "Heavy Transport",
                  unit_type: "Vehicle",
                  attack_type: 0,
                  power: 0,
                  defence: 35,
                  movement_speed: 60,
                  movement_cost: 15,
                  cargo_capacity: 10000,
                  transport_capacity: 100,
                  gold_cost: 400,
                  steel_cost: 450,
                  oil_cost: 220


     DB::Unit::Definition.create name: "Heavy Tank",
                  unit_type: "Vehicle",
                  attack_type: 0,
                  power: 140,
                  defence: 40,
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
     DB::Structure::Definition.create name: "Market", 
                 description: "Produces Gold",
                 gold_cost: 85,
                 steel_cost: 42,
                 oil_cost: 0,
                 cost_advancement_type: 0,
                 base_production: 45

     DB::Structure::Definition.create name: "Foundry",
                 description: "Produces Steel",
                 gold_cost: 73,
                 steel_cost: 64,
                 oil_cost: 0,
                 cost_advancement_type: 0,
                 base_production: 35

     DB::Structure::Definition.create name: "Refinery",
                 description: "Produces Oil",
                 gold_cost: 140,
                 steel_cost: 59,
                 oil_cost: 0,
                 cost_advancement_type: 0,
                 base_production: 15

     DB::Structure::Definition.create name: "Bank",
                 description: "Storage Room for Gold",
                 gold_cost: 2000,
                 steel_cost: 1300,
                 oil_cost: 0,
                 cost_advancement_type: 1

     DB::Structure::Definition.create name: "Warehouse",
                 description: "Storage Room for Steel and Oil",
                 gold_cost: 800,
                 steel_cost: 2000,
                 oil_cost: 500,
                 cost_advancement_type: 1

     DB::Structure::Definition.create name: "Barraks",
                 description: "Produces Infantry Units",
                 gold_cost: 400,
                 steel_cost: 200,
                 oil_cost: 100,
                 cost_advancement_type: 2

     DB::Structure::Definition.create name: "Factory",
                 description: "Produces Veicles",
                 gold_cost: 600,
                 steel_cost: 800,
                 oil_cost: 150,
                 cost_advancement_type: 2

     DB::Structure::Definition.create name: "Research Centre",
                 description: "Produces Researches",
                 gold_cost: 400,
                 steel_cost: 200,
                 oil_cost: 150,
                 cost_advancement_type: 2

     DB::Structure::Definition.create name: "Bunker",
                 description: "Increases Defence if City is Attacked",
                 gold_cost: 5000,
                 steel_cost: 10000,
                 oil_cost: 1500,
                 cost_advancement_type: 2

     #################
     #  RESEARCHES   #
     #################
     DB::Research::Definition.create name: "Infantry Weapon Upgrade",
                 description: "to-be-added",
                 gold_cost: 300,
                 steel_cost: 800,
                 oil_cost: 0

     DB::Research::Definition.create name: "Infrantry Armor Upgrade",
                 description: "to-be-added" ,
                 gold_cost: 250,
                 steel_cost: 1000,
                 oil_cost: 0  

     DB::Research::Definition.create name: "Vehicle Weapon Upgrade",
                 description: "to-be-added",
                 gold_cost: 500,
                 steel_cost: 1000,
                 oil_cost: 0

     DB::Research::Definition.create name: "Vehicle Armor Upgrade",
                 description: "to-be-added",
                 gold_cost: 400,
                 steel_cost: 800,
                 oil_cost: 400

     DB::Research::Definition.create name: "Construction Industry Tecniques",
                 description: "to-be-added",
                 gold_cost: 1200,
                 steel_cost: 1500,
                 oil_cost: 1000   

     DB::Research::Definition.create name: "Espionage",
                 description: "to-be-added",
                 gold_cost: 900,
                 steel_cost: 600,
                 oil_cost: 200

     DB::Research::Definition.create name: "Engine Power",
                 description: "to-be-added",
                 gold_cost: 1000,
                 steel_cost: 1500,
                 oil_cost: 1200
                 
                 
                 
      ##########################
      #  RESEARCH REQUIREMENTS #
      ##########################

     #Vehicle Weapon => 2 Research Centre
     DB::Research::Requirement::Building.create :tech_id => 3, :req_structure_id => 8, :level => 2
     #Vehicle Armor => 2 Research Centre
     DB::Research::Requirement::Building.create :tech_id => 4, :req_structure_id => 8, :level => 2
     #Construction Industry Tecniques => 10 Research Centre
     DB::Research::Requirement::Building.create :tech_id => 5, :req_structure_id => 8, :level => 10
     #Engine Power => 5 Research Centre, 2 Factory
     DB::Research::Requirement::Building.create :tech_id => 7, :req_structure_id => 7, :level => 2
     DB::Research::Requirement::Building.create :tech_id => 7, :req_structure_id => 8, :level => 5

     ##########################
     # STRUCTURE REQUIREMENTS #
     ##########################
     
     #Bank => 3 Market
     DB::Structure::Requirement::Building.create :structure_id => 4, :req_structure_id => 1, :level => 3
     #WareHouse => 3 Foundry, 3 Refinery
     DB::Structure::Requirement::Building.create :structure_id => 5, :req_structure_id => 2, :level => 3
     DB::Structure::Requirement::Building.create :structure_id => 5, :req_structure_id => 3, :level => 3
     #Bunker => 8 Barrak, 5 Factory
     DB::Structure::Requirement::Building.create :structure_id => 8 , :req_structure_id => 6, :level => 8
     DB::Structure::Requirement::Building.create :structure_id => 8 , :req_structure_id => 7, :level => 5
     
     #Barrak => 1 Infantry Weapon
     DB::Structure::Requirement::Tech.create :structure_id => 6, :req_tech_id => 1, :level => 1
     #Factory => 2 Vehicle Weapon, 2 Vehicle Armor
     DB::Structure::Requirement::Tech.create :structure_id => 7, :req_tech_id => 3, :level => 2
     DB::Structure::Requirement::Tech.create :structure_id => 7, :req_tech_id => 4, :level => 2
     #Bunker => 6 Infantry Weapon, 5 Vehicle Armor
     DB::Structure::Requirement::Tech.create :structure_id => 9, :req_tech_id => 1, :level => 6
     DB::Structure::Requirement::Tech.create :structure_id => 9, :req_tech_id => 4, :level => 5
     
     
     ##########################
     #   UNITS REQUIREMENTS   #
     ##########################

     #Special Forces => 4 Barrak
     DB::Unit::Requirement::Building.create :unit_id => 2, :req_structure_id => 6, :level => 4
     #Granatier => 6 Barrak, 2 Factory
     DB::Unit::Requirement::Building.create :unit_id => 3, :req_structure_id => 6, :level => 6
     DB::Unit::Requirement::Building.create :unit_id => 3, :req_structure_id => 7, :level => 2
     #Jeep => 3 Factory
     DB::Unit::Requirement::Building.create :unit_id => 4, :req_structure_id => 7, :level => 2
     #Light Tank => 6 Factory
     DB::Unit::Requirement::Building.create :unit_id => 5, :req_structure_id => 7, :level => 6
     #Light Transport => 5 Factory
     DB::Unit::Requirement::Building.create :unit_id => 6, :req_structure_id => 7, :level => 6
     #Heavy Tank => 12 Factory
     DB::Unit::Requirement::Building.create :unit_id => 7, :req_structure_id => 7, :level => 12
     #Heavy Transport
     DB::Unit::Requirement::Building.create :unit_id => 8, :req_structure_id => 7, :level => 8
     
     #Soldier => 2 Infantry Weapon
     DB::Unit::Requirement::Tech.create :unit_id => 1, :req_tech_id => 1, :level => 2
     #Special Forces => 4 Infantry Weapon, 4 Infantry Armor
     DB::Unit::Requirement::Tech.create :unit_id => 2, :req_tech_id => 2, :level => 4
     DB::Unit::Requirement::Tech.create :unit_id => 2, :req_tech_id => 3, :level => 4
     #Granatier => 6 Infantry Weapon, 6 Infantry Armor
     DB::Unit::Requirement::Tech.create :unit_id => 3, :req_tech_id => 2, :level => 6
     DB::Unit::Requirement::Tech.create :unit_id => 3, :req_tech_id => 3, :level => 6
     #Jeep => 1 Engine Power
     DB::Unit::Requirement::Tech.create :unit_id => 4, :req_tech_id => 7, :level => 1
     #Light Tank => 5 Vehicle Armor, 5 Vehicle Weapon
     DB::Unit::Requirement::Tech.create :unit_id => 5, :req_tech_id => 3, :level => 5
     DB::Unit::Requirement::Tech.create :unit_id => 5, :req_tech_id => 4, :level => 5
     #Light Transport => 5 Vehicle Armor, 3 Engine Power
     DB::Unit::Requirement::Tech.create :unit_id => 6, :req_tech_id => 3, :level => 5
     DB::Unit::Requirement::Tech.create :unit_id => 6, :req_tech_id => 7, :level => 3
     #Heavy Tank => 5 Vehicle Armor, 5 Vehicle Weapon
     DB::Unit::Requirement::Tech.create :unit_id => 7, :req_tech_id => 3, :level => 8
     DB::Unit::Requirement::Tech.create :unit_id => 7, :req_tech_id => 4, :level => 6
     #Heavy Transport => 5 Vehicle Armor, 3 Engine Power
     DB::Unit::Requirement::Tech.create :unit_id => 8, :req_tech_id => 3, :level => 8
     DB::Unit::Requirement::Tech.create :unit_id => 8, :req_tech_id => 7, :level => 6

  end

  def create_default_vals_after_location

    florence = DB::Location.create latitude: 43.7687324, longitude: 11.2569013  # firenze

    DB::City.create name: "Florence", ccode: "it", location_id: florence.id, player_id: 3

    paris = DB::Location.create latitude: 48.866667, longitude: 2.333333

    DB::City.create name: "Paris", ccode: "fr", location_id: paris.id, player_id: 2

    army = DB::Army.create location_id: florence.id,
                    player_id: 3,
                    is_moving: 0              

    DB::Army.create location_id: florence.id,
                    player_id: 2,
                    is_moving: 1,
                    destination_id: paris.id

  #ARMY 1
    DB::Unit::ArmyUnit.create unit_id: 1,
                       army_id: 1,
                       player_id: 3,
                       number: 100 #100 soldiers

    DB::Unit::ArmyUnit.create unit_id: 3,
                        army_id: 1,
                        player_id: 3,
                        number: 20 #20 granatiers

    DB::Unit::ArmyUnit.create unit_id: 5,
                        army_id: 1,
                        player_id: 3,
                        number: 10 #10 light camions

  #ARMY 2
    DB::Unit::ArmyUnit.create unit_id: 2,
                        army_id: 2,
                        player_id: 2,
                        number: 50 #50 special forces

    DB::Unit::ArmyUnit.create unit_id: 4,
                        army_id: 2,
                        player_id: 2,
                        number: 5 #5 jeeps

  end
  
end