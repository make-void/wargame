module LG
  module Queue
    class BuildingQueue
      DB_CLASS = DB::Queue::Building
      include Modules::Queue
      
      attr_reader :items
      
      def add_item(city_object, object, level_or_number)    
        return false
      end
      
    end
  end
end