module LG
  module Queue
    class BuildingQueue
      include Modules::Queue
      DB_CLASS = DB::Queue::Building
      
      attr_reader :items
      
      def initialize
        
      end
      
      def add_item(city_object, object, level_or_number)    
        return false
      end
      
    end
  end
end