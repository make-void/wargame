class Game
  constructor: ->
    @map = new Map
    @current_player = null
    @current_playerView = null
  
  initModels: ->  
    types = ["struct", "tech", "unit"]
    # "".pluralize
    # eval("types")
    # Structs
    #   Struct
    # Techs 
    #   Tech
    # Units
    #   Unit
      
        
    # Location  = Backbone.Model.extend {}
    # Army      = Location.extend {}
    # City      = Location.extend {}
    # Player    = Backbone.Model.extend {}
    # Upgrade   = Backbone.Model.extend {}
    # Alliance  = Backbone.Model.extend {}
    # 
    # Struct = Backbone.Model.extend {}
    # Unit = Backbone.Model.extend {}
    # Tech = Backbone.Model.extend {}
    # 
    # Structs = Backbone.Model.extend {}
    # Units = Backbone.Model.extend {}
    # Techs = Backbone.Model.extend {}
  
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