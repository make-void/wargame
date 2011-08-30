# TODO: move utils in a separate file  

utils = {}

utils.parseCoords = (string) ->
  split = string.replace(/\s/, '').split(",")
  return [split[0], split[1]]

#use console.log safely
unless console
  console = {} 
  console.log = {}


$( ->
  g = window # makes the variable global (so you can test it in console an you can call it from outside jquery domready)
  
  # --------
  # demo of constructing a model & a views
    
  g.army_test = new Army { asd: "lol" }
  g.armyMarker = new ArmyMarker { model: army_test }
  $("#debug").append armyMarker.render().el

  # --------
  # unit

  
  # --------
  # nav
  
  $("#nav li").hover( ->
    $(this).find("div").show()
  , ->
    $(this).find("div").hide()    
  )

  # --------  
  # debug
    
  $("#latLng").bind("submit", ->
    coords = $(this).find("input").val()
    coords = utils.parseCoords(coords)
    map.center(coords[0], coords[1])
    return false
  )
  
  $(window).oneTime(1000, ->
    army = null
    for marker in map.markers
      # console.log marker
      if marker.type == "army"
        army = marker          
        break

    # console.log "loc:", army.dialog.el
    
    
    # TODO: delete me?
    #

    window.arm = army
    # army.dialog.render()
    # $(army.dialog.el).find(".move").trigger("click")
  )
  
  # --------
  # map
  
  
  g.map = new Map
  map.draw()
  #map.dialogs()
  map.loadMarkers()
  map.listen()
  #map.clickInfo()
  map.startFetchingMarkers()
  #map.overlay()
  map.autoSize()
  
  # map.debug()

  #note: if (navigator.userAgent.match("iPad")) ...
)
