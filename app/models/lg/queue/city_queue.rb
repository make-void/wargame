module LG
  module Queue
    class CityQueue
        
      attr_reader :errors, :unit_queue, :building_queue, :research_queue
      QUEUE_TYPES = [:all, :unit, :building, :research]
      
      
      private_class_method :new
      
      @@queue_cache = {}
      
      
      def self.get( city_id, player_id )
        return @@queue_cache["#{city_id}_#{player_id}"] if !@@queue_cache["#{city_id}_#{player_id}"].nil? && Rails.env != "testing"
        instance = new(city_id, player_id)
        @@queue_cache["#{city_id}_#{player_id}"] = instance
        instance.get #Initialize Items
        return instance
      end
      
      def get
        return { units: [], structs: [], techs: [], errors: @errors } if has_errors?
        # { city: @city, player: @player } 
        get_queue :all
        structs = building_queue.items.map{ |bq| bq.attributes }
        techs   = research_queue.items.map{ |bq| bq.attributes }
        units   = unit_queue.items.map{ |bq| bq.attributes }
        { units: units, structs: structs, techs: techs, errors: @errors }
      end
      
      def initialize( city_id, player_id )
        @city = DB::City.find(:first, :conditions => {:city_id => city_id})
        @player = DB::Player.find(:first, :conditions => {:player_id => player_id})
        
        @errors = []
        @errors.push("City #{city_id} Does Not Exist") if @city.nil?
        @errors.push("Player #{city_id} Does Not Exists") if @player.nil?
        @errors.push("City #{city_id} Is Not Of Player #{player_id}") unless ( ( !@city.nil? ) && ( @city.player_id == @player.player_id ) )
        
        @unit_queue = LG::Queue::UnitQueue.new
        @building_queue = LG::Queue::BuildingQueue.new
        @research_queue = LG::Queue::ResearchQueue.new
      end
      
      def has_errors? ; errors.size != 0 ; end
      
      def get_queue( type )
        return @errors if has_errors?
        raise ArgumentError, "Need Type in #{QUEUE_TYPES.inspect}, got #{type}" unless QUEUE_TYPES.include?(type)
        case type
          when :all
            get_unit_queue()
            get_building_queue()
            get_research_queue()
          when :unit
            get_unit_queue()
          when :building
            get_building_queue()
          when :research 
            get_research_queue()
        end
      end
      
      def add_to_queue( type, object, level_or_number )
        return @errors if has_errors? #To Be Sure all is Fine!
        raise ArgumentError, "Need Type in #{(QUEUE_TYPES - [:all]).inspect}, got #{type}" unless (QUEUE_TYPES - [:all]).include?(type)
        raise ArgumentError, "Need level to be a Number. got #{level_or_number.inspect}" unless level.is_a?(Numeric)
        case type
          when :unit
            #GET BUILDING LEVEL FOR THIS PLAYER
            cost = LG::Unit.cost(object, level_or_number)
            return @unit_queue.add_item(city_object, object, level_or_number)
          when :building
            #GET RESEARCH LEVEL FOR THIS PLAYER
            cost = LG::Structures.cost(object, level_or_number)
            return @building_queue.add_item(object, level_or_number)
          when :research 
            #GET BUILDING LEVEL FOR THIS PLAYER
            return @research_queue.add_item(city_object, object, level_or_number) 
        end
      end
      
      private
      
      def get_unit_queue
        @unit_queue.items = DB::Queue::Unit.find(:all, :conditions => { player_id: @player.player_id, city_id: @city.city_id}, :order => "started_at")
      end
      def get_building_queue
        @building_queue.items = DB::Queue::Building.find(:all, :conditions => { player_id: @player.player_id, city_id: @city.city_id}, :order => "started_at")
      end
      def get_research_queue
        @research_queue.items = DB::Queue::Tech.find(:all, :conditions => { player_id: @player.player_id, city_id: @city.city_id}, :order => "started_at")
      end
      
      
    end
  end
end