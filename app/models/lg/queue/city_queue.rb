module LG
  module Queue
    class CityQueue
        
      attr_reader :errors, :unit_queue, :building_queue, :research_queue, :city      
      
      QUEUE_TYPES = [:all, :unit, :building, :research]
      
      NAMES = {
        # table => column
        structs: { klass: :structure, queue: :building }, 
        techs: { klass: :research, queue: :tech, id_name: :tech }, #  FIXME: id_name is pathetic, rename all "structure_id" in "struct_id" pleaaaase! (also think about naming difference between tech,research and upgrades, with version control should be easy to rename)
        units: { klass: :unit, queue: :unit },
      }      
      
      private_class_method :new
      
      @@queue_cache = {}
      
      
      def self.get( city_id, player_id )
        cached_instance = @@queue_cache["#{city_id}_#{player_id}"] if !@@queue_cache["#{city_id}_#{player_id}"].nil? && Rails.env != "testing"
        if cached_instance.nil? #Adjust Cache if needed
          instance = new(city_id, player_id)
          instance.get 
          @@queue_cache["#{city_id}_#{player_id}"] = instance
        else
          cached_instance.get
          @@queue_cache["#{city_id}_#{player_id}"] = cached_instance
          instance = cached_instance
        end
        #Initialize Items
        return instance
      end
      
      # :unit, 1
      def destroy_queue_item( type, object_id, level_or_number )
       # city_id: attrs.city_id, player_id: attrs.player_id, structure_id: attrs.structure_id, unit_id: attrs.unit_id
       return @errors if has_errors? #To Be Sure all is Fine!
       raise ArgumentError, "Need Type in #{(QUEUE_TYPES - [:all]).inspect}, got #{type}" unless (QUEUE_TYPES - [:all]).include?(type)
       raise ArgumentError, "Need level to be a Number. got #{level_or_number.inspect}" unless level_or_number.is_a?(Numeric)
       
       case type
         when :unit
           object = DB::Unit::Definition.find(object_id)
           return @unit_queue.destroy(@city, object, level_or_number )
         when :building
           object = DB::Structure::Definition.find(object_id)
           return @building_queue.destroy(@city, object, level_or_number )
         when :research 
           object = DB::Research::Definition.find(object_id)
           return @research_queue.destroy(@city, object, level_or_number ) 
       end
      end
      
      
      def self.klass(type)
        key = type.to_s.pluralize.to_sym
        NAMES.fetch(key).fetch(:queue).to_s.camelcase
      end
      
      def initialize( city_id, player_id )
        @city = DB::City.find(:first, :conditions => {:city_id => city_id})
        @player = DB::Player.find(:first, :conditions => {:player_id => player_id})
        
        @errors = []
        @errors.push("City #{city_id} does not exist") if @city.nil?
        @errors.push("Player #{city_id} does not exists") if @player.nil?
        @errors.push("City #{city_id} is not of player #{player_id}") unless ( ( !@city.nil? ) && ( @city.player_id == @player.player_id ) )
        
        @unit_queue = LG::Queue::UnitQueue.new
        @building_queue = LG::Queue::BuildingQueue.new
        @research_queue = LG::Queue::ResearchQueue.new
      end
      
      def get
        return { errors: @errors } if has_errors?
        # { city: @city, player: @player } 
        get_queue :all
        structs = building_queue.items.map{ |bq| bq.attributes.merge(type: "struct") }
        techs   = research_queue.items.map{ |bq| bq.attributes.merge(type: "tech") }
        results = structs + techs
        DB::Unit::Definition::UNIT_TYPES.each do |x| #Refactor? for Now, he merges the 2 queues for units...
          results + unit_queue.items[x].map{ |bq| bq.attributes.merge(type: "unit") }
        end
        return results
      end
      
      def has_errors? ; errors.size != 0 ; end
      
      def add_to_queue( type, object_id, level_or_number )
        return @errors if has_errors? #To Be Sure all is Fine!
        raise ArgumentError, "Need Type in #{(QUEUE_TYPES - [:all]).inspect}, got #{type}" unless (QUEUE_TYPES - [:all]).include?(type)
        raise ArgumentError, "Need level to be a Number. got #{level_or_number.inspect}" unless level_or_number.is_a?(Numeric)
        case type
          when :unit
            object = DB::Unit::Definition.find(object_id)
            return @unit_queue.add_item(@city, object, level_or_number)
          when :building
            object = DB::Structure::Definition.find(object_id)
            return @building_queue.add_item(@city, object, level_or_number)
          when :research 
            object = DB::Research::Definition.find(object_id)
            return @research_queue.add_item(@city, object, level_or_number) 
        end
      end
      
      private
      
      def get_queue( type )
        raise ArgumentError, "Need Type in #{QUEUE_TYPES.inspect}, got #{type}" unless QUEUE_TYPES.include?(type)
        case type
          when :all
            get_unit_queues()
            get_building_queue()
            get_research_queue()
          when :unit
            get_unit_queues()
          when :building
            get_building_queue()
          when :research 
            get_research_queue()
        end
      end
      
      def get_unit_queues
        @unit_queue.items = DB::Queue::Unit.find(:all, :conditions => { player_id: @player.player_id, city_id: @city.city_id, finished: false }, :order => "created_at")
      end
      def get_building_queue
        @building_queue.items = DB::Queue::Building.find(:all, :conditions => { player_id: @player.player_id, city_id: @city.city_id, finished: false }, :order => "created_at")
      end
      def get_research_queue
        @research_queue.items = DB::Queue::Tech.find(:all, :conditions => { player_id: @player.player_id, city_id: @city.city_id, finished: false }, :order => "created_at")
      end
      
    end
  end
end