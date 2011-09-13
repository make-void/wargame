class Game
  constructor: ->
    @map = new Map
    @current_player = null
    @current_playerView = null
    @struct_def
    @tech_def   
    @unit_def   
    
  debug: ->
    debug = new Debug this
    debug.debug()
    
  initGameView: ->
    @game_view = new GameView()
    # TODO: render the gameview
    window.Spinner = new SpinnerView()
  
  
  initModels: ->  
    definitions = new Definitions()
    definitions.get( (defs) =>
      @struct_def  = new StructDef defs   
      @tech_def    = new TechDef   defs
      @unit_def    = new UnitDef   defs       
      # TODO: insert event trigger here to listen somewhere afterwards 
    )
    # types = ["struct", "tech", "unit"]
    # for type in types
    #   klass = type.pluralize().capitalize()
    #   klass = eval klass
    #   dialog = eval "#{klass}Dialog"
    
    # init here
    
    
    g = window
    g.Cities = new CitiesList()  
    g.Armies = new ArmiesList()

    cities_view = new CitiesView()
    # $("nav .cities").html cities_view.render().el
    armies_view = new ArmiesView()
    
    Cities.fetch()
    
    # debug:
    $($("#nav li")[1]).find("div").show()
    
    this

  
  initMap: ->  
    @map.draw()
    @map.loadMarkers()
    # @map.clickInfo()
    @map.markersUpdateStart()
    @map.restoreState()
    # @map.debug("move")
    # @map.debug("attack")

  getPlayerView: ->
    $.getJSON("/players/me", (player) =>
      this.initPlayerView player
    )
  
  initPlayerView: (player) ->
    @current_player = new Player player
    @current_playerView = new PlayerView { model: @current_player }
    @current_playerView.render()


  initNav: ->
    $("#nav li").hover( ->
      $(this).find("div").show()
    , ->
      $(this).find("div").hide()    
    )