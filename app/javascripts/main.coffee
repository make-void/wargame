$( ->
  g = window # makes the variable global (so you can test it in console an you can call it from outside jquery domready)
  
  g.game = new Game
  game.initModels()
  game.initGameView() # TODO: FIXME:  gameview should contain map, playerview and nav
  game.initMap()
  game.getPlayerView()
  game.initNav()

  game.debug() # TODO: remove in production
  #note: if (navigator.userAgent.match("iPad")) ...
)