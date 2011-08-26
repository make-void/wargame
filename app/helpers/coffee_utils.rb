module CoffeeUtils
  COFFEE_FILES = [ "dialogs/dialog"           ,
                   "dialogs/city_dialog"      ,
                   "dialogs/army_dialog"      ,
                   "utils"                    ,
                   "models"                   ,
                   "map"                      ,
                   "main"                     ,
                 ]

  APP_ROOT = Rails.root
  # private

  def coffee_dir
    "#{APP_ROOT}/public/javascripts"
  end

  def coffee_files
    COFFEE_FILES.map do |c|
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
    puts `#{cd_js} coffee -j main.js -b  -c #{coffee_files}`
  end

  
  # public
  
  def compile_coffeescripts
    if Rails.env == "development"
      do_compilation if coffee_installed   
    end
  end
end