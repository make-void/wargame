beforeEach( ->
  this.addMatchers({
    toBeArray: ->
      typeof(this) == "object" && this.length

    # toBeA: (klass) ->
    #   switch klass 
    #     when "Player" then expect(this.attributes.name).toEqual("Cor3y")
    #     else "Object class: #{klass} -  not found!"
  })
)


describe("Game", ->
  it "initializes the map", ->
    game = new Game()
    # game.initMap()
    # expect(game.map.makers).toBeArray()
    # TODO: figure out how to test the gmap
    
  it "initializes the player", ->
    game = new Game()
    player_json = '{"alliance_id":2,"created_at":"2011-08-31T13:19:14Z","email":"test1@test.test","name":"Cor3y","player_id":2}'
    player = JSON.parse player_json
    loadFixtures("player_view.html")
    game.initPlayerView player
    console.log "player: ", game.current_player
    # expect(game.current_player).toBeA("Player")
    expect(game.current_player.attributes.name).toEqual("Cor3y")
    # toBeTruthy
    
  it "shows the playerView", ->
    game = new Game()
    game.initPlayerView()
    # toHaveText()
)
