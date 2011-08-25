module CoffeeUtils
  COFFEE_FILES = %w(utils map main)

  def coffee_installed
    !`which coffee`.blank?
  end

  def cd_js
    "cd #{Rails.root}/public/javascripts;"
  end

  def do_compilation
    puts `#{cd_js} coffee -j main.js -b  -c #{COFFEE_FILES.map{|c| "#{c}.coffee"}.join(" ")}`
  end

  def compile_coffeescripts
    if Rails.env == "development"
      do_compilation if coffee_installed   
    end
  end
end