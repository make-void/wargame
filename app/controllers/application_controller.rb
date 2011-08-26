class ApplicationController < ActionController::Base
  protect_from_forgery
  
 # require "#{Rails.root}/app/helpers/controllers_utils"
 
  include ControllersUtils
  
end
