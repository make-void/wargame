class Game
  constructor: ->
    window.map = @map = new Map

  drawMap: ->  
    @map.draw()
    # @map.dialogs()
    @map.loadMarkers()
    @map.listen()
    # @map.clickInfo()
    @map.startFetchingMarkers()
    # @map.overlay()
    @map.autoSize()
    # @map.debug("move")
    # @map.debug("attack")

  drawPlayerView: ->
    $.getJSON("/players/me", (player) ->
      current_player = new Player player
      playerView = new PlayerView { model: current_player }
      $("#player").append playerView.render().el
    )

  drawNav: ->
    $("#nav li").hover( ->
      $(this).find("div").show()
    , ->
      $(this).find("div").hide()    
    )

$( ->
  g = window # makes the variable global (so you can test it in console an you can call it from outside jquery domready)
  
  g.game = new Game
  game.drawMap()
  game.drawPlayerView()
  game.drawNav()

  #note: if (navigator.userAgent.match("iPad")) ...
)