module Modules
  module Queue
  
    def Queue.included(classe_di_arrivo)
      classe_di_arrivo.class_eval do
        extend ClassMethods
        include InstanceMethods
      end
    end
    
    
    module ClassMethods
    
    end
    
    module InstanceMethods
      def items=( db_entries_array )
        raise ArgumentError, "Need an array of DB::Queue::Unit. Got #{db_entries_array.map{|x| x.class}.uniq.inspect}" if db_entries_array != [] && db_entries_array.map{|x| x.class}.uniq != [DB_CLASS]
        @items = db_entries_array
      end
      
      def city_hash_money?(city_object, cost_hash)
        raise ArgumentError, "Need cost_hash to have a :gold key. Got #{cost_hash.inspect}" if cost_hash[:gold].nil?
        raise ArgumentError, "Need cost_hash to have a :steel key. Got #{cost_hash.inspect}" if cost_hash[:steel].nil?
        raise ArgumentError, "Need cost_hash to have a :oil key. Got #{cost_hash.inspect}" if cost_hash[:oil].nil?
        return @city.has_resources?( cost_hash )
      end
    end
    
  end
end