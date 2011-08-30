GameState = { 
  current: "browse",
  states: ["browse", "move", "attack"]
  
  # redefine current= and act on status change
  
}

UI = {}
UI.moving = {}
UI.moving.show = (location) ->
  # change cursor
  line = null
  # draw a line
  mapListen = $("#map_canvas").bind
  mapListen = google.maps.event.addListener
  map = window.map.map

  loc = location.attributes
  mapListen(map, "mousemove", (evt) ->
    points = [
      new google.maps.LatLng(loc.latitude, loc.longitude),
      new google.maps.LatLng(evt.latLng.Oa, evt.latLng.Pa) 
    ]
    #console.log "moved: #{evt.pageX}, #{evt.pageY}"
    line.setMap(null) if line
    
    line = new google.maps.Polyline({
      path: points,
      strokeColor: "#FF0000",
      strokeOpacity: 1.0,
      strokeWeight: 2
    });
    line.setMap(map)
    
  )
  
  
  

ArmyDialog  = Dialog.extend(
  initialize: ->
    selector = "#armyDialog-tmpl"
    Dialog.prototype.initialize selector # how to call super in js
  
  activateButtons: ->
    model = this.model
    $(this.el).find(".move").bind('click', ->
      console.log("moving")
      UI.moving.show(model)
      GameState.current = "move"
    )
    
    $(this.el).find(".attack").bind('click', ->
      console.log("attaaaack!")
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