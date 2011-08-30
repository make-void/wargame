GameState = { 
  current: "browse",
  states: ["browse", "move", "attack"]
  
  # redefine current= and act on status change
  
}


class MapAttack
  constructor: (location) ->

  draw: (evt) ->
    

class MapMove
  constructor: (location) ->
    # TODO: change cursor
    @line = null
    @active = true
    this.map = window.map.map
    loc = location.attributes
    google.maps.event.addListener(this.map, "mousemove", (evt) => 
      this.draw(loc, evt)
    )
    this.deactivationHook()

  draw: (loc, evt) ->
    points = [
      new google.maps.LatLng(loc.latitude, loc.longitude),
      evt.latLng
    ]
    #console.log "moved: #{evt.pageX}, #{evt.pageY}"
    @line.setMap(null) if @line
    
    if @active
      @line = new google.maps.Polyline({
        path: points,
        strokeColor: "#FF0000",
        strokeOpacity: 1.0,
        strokeWeight: 2
      });
      @line.setMap this.map
  
    
  deactivationHook: ->
    $("#map_canvas").bind("click", =>
      this.deactivate()
    )

  deactivate: ->
    @line.setMap null
    @active = false

ArmyDialog  = Dialog.extend(
  initialize: ->
    selector = "#armyDialog-tmpl"
    Dialog.prototype.initialize selector # how to call super in js
  
  activateButtons: ->
    model = this.model
    $(this.el).find(".move").bind('click', ->
      console.log("moving")
      map_move = new MapMove(model)
      # map_move.deactivate()
      GameState.current = "move"
    )
    
    $(this.el).find(".attack").bind('click', ->
      console.log("attaaaack!")
      map_attack = new MapAttack(model)      
      # map_attack.deactivate()
      GameState.current = "move"
    )
    


  afterRender: ->
    haml = Haml($("#armyActionsMenu-tmpl").html())
    content = haml({})
    $(this.el).find(".commands").append content
    
    
    this.activateButtons()
  
  label: ->
    player.name
)