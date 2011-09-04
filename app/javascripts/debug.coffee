# DON'T include this in prodction!!!

# debug

class Debug
  constructor: (@game) ->
    @map = @game.map
    
  debug: ->
    this.debugDialog()
    
  debugDialog: ->
    setTimeout( => 
      console.log "markers: #{@map.markers.length}"
      for marker in @map.markers
        console.log marker.type
        if marker.type == "city"
          @map.attachDialog marker
          setTimeout( -> # TODO: remove this damneds setTimeouts!!!!
            marker.dialog_view.switchTab("city_units")
          , 1000)
        return 
    , 1500)
    
    

$("#latLng").bind("submit", ->
  coords = $(this).find("input").val()
  coords = Utils.parseCoords(coords)
  map.center(coords[0], coords[1])
  return false
)


# debug .move or .attack

# $(window).oneTime(1000, ->
#   army = null
#   for marker in map.markers
#     # console.log marker
#     if marker.type == "army"
#       army = marker          
#       break
# 
#   # console.log "loc:", army.dialog.el
#   window.arm = army
#   # army.dialog.render()
#   # $(army.dialog.el).find(".move").trigger("click")
#   # # $(army.dialog.el).find(".attack").trigger("click")
# )