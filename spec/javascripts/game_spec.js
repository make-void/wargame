(function() {
  describe("Game", function() {
    it("initializes the map", function() {
      var game;
      return game = new Game();
    });
    it("initializes the player", function() {
      var game, player, player_json;
      game = new Game();
      player_json = '{"alliance_id":2,"created_at":"2011-08-31T13:19:14Z","email":"test1@test.test","name":"Cor3y","player_id":2}';
      player = JSON.parse(player_json);
      loadFixtures("player_view.html");
      game.initPlayerView(player);
      return expect(game.current_player.attributes.name).toEqual("Cor3y");
    });
    return it("shows the playerView", function() {
      var game;
      game = new Game();
      return game.initPlayerView();
    });
  });
}).call(this);
