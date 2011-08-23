module ControllersUtils
  
  COFFEE_FILES = %w(map main)
  
  def coffee_installed
    !`which coffee`.blank?
  end
  
  def cd_js
    "cd #{Rails.root}/public/javascripts;"
  end

  def do_compilation
    puts `#{cd_js} coffee -j main.js -c #{COFFEE_FILES.map{|c| "#{c}.coffee"}.join(" ")}`
  end
  
  def compile_coffeescripts
    if Rails.env == "development"
      do_compilation if coffee_installed   
    end
  end
end

class GameController < ApplicationController
  
  #require "#{Rails.root}/app/helpers/controllers_utils"
  include ControllersUtils
  before_filter :compile_coffeescripts
  
  def show
    
  end
  
end