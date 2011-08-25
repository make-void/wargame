module ControllersUtils
  
  # main utils
  
  CU_HELPERS = [:is_on?]
  
  def is_on?(route)
    contr, act = route.to_s.split("#")
    self.controller_name == contr && self.action_name == act
  end
  
  def self.included(obj)
    obj.helper_method CU_HELPERS
  end
  
  include CoffeeUtils
  
end
