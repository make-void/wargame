module DefaultValuesDev

  def create_default_vals_dev
    ally = DB::Alliance.create name: "TheMasterers"

    cor3y = DB::Player.create name: "Cor3y", 
                  new_password: "daniel001", 
                  new_password_confirmation: "daniel001", 
                  email: "test1@test.test", 
                  alliance_id: ally.id

    makevoid = DB::Player.create name: "makevoid", 
                  new_password: "finalman", 
                  new_password_confirmation: "finalman", 
                  email: "test2@test.test", 
                  alliance_id: ally.id
    


    latLng = { latitude: 43.7687324, longitude: 11.2569013 }
    florence = DB::Location.where(latLng).first # firenze
    florence = DB::Location.create latLng unless florence

    f_city = DB::City.find(:first, :conditions => {:name => "Florence"})
    if f_city.nil?
      f_city = DB::City.create name: "Florence", ccode: "it", location_id: florence.id, player_id: makevoid.id, pts: 65000
    else
      f_city.update_attributes player_id: makevoid.id, pts: 65000
    end

    latLng = { latitude: 48.866667, longitude: 2.333333 }
    paris = DB::Location.where(latLng).first
    paris = DB::Location.create latLng unless paris

    paris_city = DB::City.find(:first, :conditions => {:name => "Paris"})
    if paris_city.nil?
      paris_city = DB::City.create name: "Paris", ccode: "fr", location_id: paris.id, player_id: cor3y.id, pts: 65000
    else
      paris_city.update_attributes player_id: cor3y.id, pts:65000
    end

    army_1 = DB::Army.create location_id: florence.id,
                    player_id: cor3y.id,
                    is_moving: 0

    latLng = { latitude: 43.75, longitude: 11.183333 }
    scandicci = DB::Location.where(latLng).first
    if scandicci
      army_2 = DB::Army.create location_id: scandicci.id,
                      player_id: makevoid.id,
                      is_moving: 0
    end

    latLng = { latitude: 43.683333, longitude: 11.25 }
    impruneta = DB::Location.where(latLng).first
    if impruneta
      army_3 = DB::Army.create location_id: impruneta.id,
                      player_id: cor3y.id,
                      is_moving: 1,
                      destination_id: paris.id
    end

  #ARMY 1
    DB::Unit::ArmyUnit.create unit_id: 1,
                       army_id: army_2.id,
                       player_id: makevoid.id,
                       number: 100 #100 soldiers

    DB::Unit::ArmyUnit.create unit_id: 3,
                        army_id: army_2.id,
                        player_id: makevoid.id,
                        number: 20 #20 granatiers

    DB::Unit::ArmyUnit.create unit_id: 5,
                        army_id: army_2.id,
                        player_id: makevoid.id,
                        number: 10 #10 light camions

  #ARMY 2
    DB::Unit::ArmyUnit.create unit_id: 2,
                        army_id: army_3.id,
                        player_id: cor3y.id,
                        number: 50 #50 special forces

    DB::Unit::ArmyUnit.create unit_id: 4,
                        army_id: army_1.id,
                        player_id: cor3y.id,
                        number: 5 #5 jeeps

  end

end