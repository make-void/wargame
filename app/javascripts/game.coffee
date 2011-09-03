class Game
  constructor: ->
    @map = new Map
    @current_player = null
    @current_playerView = null
  
  initModels: ->  
    
    definitions = new Definitions()
    definitions.get = (def) =>
      @struct_def  = new StructDef (defs)
      @tech_def    = new TechDef   (defs)
      @unit_def    = new UnitDef   (defs)    
    # types = ["struct", "tech", "unit"]
    # for type in types
    #   klass = type.pluralize().capitalize()
    #   klass = eval klass
    #   dialog = eval "#{klass}Dialog"

  
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