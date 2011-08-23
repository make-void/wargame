module LG
  class Army
    
    def initialize( army_id )
      raise ArgumentError, "Need an ArmyID. Got #{army_id.inspect}" if army_id.nil?
      @army_id = army_id
      @db_entry = DB::Army.find(@army_id)
      @units = ArmyUnit.find(:all, conditions: { army_id: @army_id})
    end
    
    def capacity
      count = 0
      @units.each{|x| count += (x.resources_transported * x.number) }
      return count
    end
    
    def speed #TODO -> Add count on #people_transported to INCREMENT speed from MIN
      @units.map(&:speed).min
    end
    
    def consumption #TODO -> Check to reduce consumption if the speed is not MAX
      count = 0
      @units.map{|x| count += (x.cost * x.number)}
      return count
    end
    
    def overall_power
      count = 0
      @units.each{|x| count += (x.power * x.number) }
      return count
    end
    
    def overall_defence
      count = 0
      @units.each{|x| count += (x.defence * x.number) }
      return count    end
    
    def refresh!
      @db_entry = DB::Army.find(@army_id)
      @units = ArmyUnit.find(:all, conditions: { army_id: @army_id})
      return true
    end
    
    def to_s
      @db_entry.inspect + "\n" + @units.inspect
    end
      
  end
end



# module Location
#   def ArReadOnly.included(classe_di_arrivo)
#     classe_di_arrivo.class_eval do
#       extend ClassMethods if AR_READONLY
#       include InstanceMethods if AR_READONLY
#     end
#   end
#   
#   module ClassMethods
#   
#   end
#   
#   module InstanceMethods
#       def readonly? ; true ; end
#   end
# end