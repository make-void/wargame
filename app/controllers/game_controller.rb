module ControllersUtils
  
  def coffee_installed
    `coffee -v` =~ /CoffeeScript version/
  end
  
  def do_compilation
    
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