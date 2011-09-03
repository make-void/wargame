
class Definitions
  constructor: ->
    
  get: (fn) ->
    $.getJSON("/definitions", (data) ->
      fn(data)
    )
    
class Game
  constructor: ->
    @map = new Map
    @current_player = null
    @current_playerView = null
    @struct_def
  
  initModels: ->  
    definitions = new Definitions()
    definitions.get( (defs) =>
      @struct_def  = new StructDef (defs)
      @tech_def    = new TechDef   (defs)
      @unit_def    = new UnitDef   (defs)    
      # console.log @unit_def
      
      # TODO: insert event trigger here to listen somewhere afterwards 
    )
    # types = ["struct", "tech", "unit"]
    # for type in types
    #   klass = type.pluralize().capitalize()
    #   klass = eval klass
    #   dialog = eval "#{klass}Dialog"
    this

  
  initMap: ->  
    @map.draw()
    # @map.dialogs()
    @map.loadMarkers()
    # @map.clickInfo()
    @map.markersUpdateStart()
    # @map.debug("move")
    # @map.debug("attack")

  getPlayerView: ->
    $.getJSON("/players/me", (player) =>
      this.initPlayerView player
    )
  
  initPlayerView: (player) ->
    @current_player = new Player player
    @current_playerView = new PlayerView { model: @current_player }
    $("#player").append @current_playerView.render().el

  initNav: ->
    $("#nav li").hover( ->
      $(this).find("div").show()
    , ->
      $(this).find("div").hide()    
    )