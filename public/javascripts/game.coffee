class Game
  constructor: ->
    @map = new Map
    @current_player = null
    @current_playerView = null
    
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