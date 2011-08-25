class GameController < ApplicationController
  
  require "#{Rails.root}/app/helpers/controllers_utils"
  include ControllersUtils
  before_filter :compile_coffeescripts
  
  def show
    
  end
  
end