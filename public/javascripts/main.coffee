$( ->
  g = window # makes the variable global (so you can test it in console an you can call it from outside jquery domready)
  
  g.game = new Game
  game.initModels()
  game.initMap()
  game.getPlayerView()
  game.initNav()

  #note: if (navigator.userAgent.match("iPad")) ...
)