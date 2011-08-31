module LG
  class Queue
      
    attr_reader :errors, :unit_queue, :building_queue, :research_queue
    QUEUE_TYPES = [:all, :unit, :building, :research]
    
    
    private_class_method :new
    
    @@queue_cache = {}
    
    
    def self.get( city_id, player_id )
      return @@queue_cache["#{city_id}_#{player_id}"] unless @@queue_cache["#{city_id}_#{player_id}"].nil?
      @@queue_cache["#{city_id}_#{player_id}"] = self.send(:new, city_id, player_id)
    end
    
    def initialize( city_id, player_id )
      @city = DB::City.find(:first, :conditions => {:city_id => city_id})
      @player = DB::Player.find(:first, :conditions => {:player_id => player_id})
      
      @errors = []
      @errors.push("City #{city_id} Does Not Exist") if @city.nil?
      @errors.push("Player #{city_id} Does Not Exists") if @player.nil?
      @errors.push("City #{city_id} Is Not Of Player #{player_id}") unless ( ( !@city.nil? ) && ( @city.player_id == @player.player_id ) )
      
      @unit_queue = []
      @builgind_queue = []
      @research_queue = []
    end
    
    def has_errors? ; errors.size != 0 ; end
    
    def get_queue( type )
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
    
    private
    
    def get_unit_queue
      @unit_queue = DB::Queue::Unit.find(:all, :conditions => { player_id: @player.player_id, city_id: @city.city_id}, :order => "started_at")
    end
    def get_building_queue
      @building_queue = DB::Queue::Building.find(:all, :conditions => { player_id: @player.player_id, city_id: @city.city_id}, :order => "started_at")
    end
    def get_research_queue
      @research_queue = DB::Queue::Tech.find(:all, :conditions => { player_id: @player.player_id, city_id: @city.city_id}, :order => "started_at")
    end
    
    
  end
end