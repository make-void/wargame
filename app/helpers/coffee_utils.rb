module CoffeeUtils
  def coffee_files 
    files = [ 
      "game_state"               ,
      "views/player_view"        ,
      "views/map_view"           ,
      "views/dialog_view"        ,
      "views/marker_view"        ,
      "views/queue_view"        ,
      "markers/city_marker_icon" ,
      "dialogs/dialog"           ,
      "dialogs/city_dialog"      ,
      "dialogs/army_dialog"      ,
      "dialogs/city/overview"  ,
      "dialogs/city/structs_dialog"  ,
      "dialogs/city/units_dialog"    ,
      "dialogs/city/techs_dialog"    ,
      "views/map_action"         ,
      "views/map_attack"         ,
      "views/map_move"           ,   
      "models/definitions"       ,
      "map/markers_updater"      ,          
      "utils"                    ,
      "definitions"              ,
      "models"                   ,
      "map"                      ,
      "game"                     ,
      "main"                     ,
    ] # you can use 'folder/*' but that way you have no control on the load order
    files << "debug" unless Rails.env == "production"
    files
  end
        
  APP_ROOT = Rails.root
  # private

  def coffee_dir
    "#{APP_ROOT}/app/javascripts"
  end
  
  def output_dir
    "#{APP_ROOT}/public/javascripts"
  end
  
  def coffee_files_string
    coffee_files.map do |c|
      if c =~ /\*/ 
        dir = c.gsub(/\/\*/, '')
        Dir.glob "#{coffee_dir}/#{dir}/*"
      else
        "#{c}.coffee"
      end
    end.flatten.join(" ")
  end

  def coffee_installed
    !`which coffee`.blank?
  end

  def cd_js
    "cd #{coffee_dir};"
  end

  def do_compilation
    puts `#{cd_js} coffee -j #{output_dir}/main.js -b  -c #{coffee_files_string}`
  end

  
  # public
  
  def compile_coffeescripts
    if Rails.env == "development"
      do_compilation if coffee_installed   
    end
  end
end