# DON'T include this in prodction!!!

# debug

class Debug
  constructor: (@game) ->
    @map = @game.map
    
  debug: ->
    # this.debugDialog()
    
  debugDialog: ->
    setTimeout( => 
      console.log "markers: #{@map.markers.length}"
      for marker in @map.markers
        console.log marker.type
        if marker.type == "city"
          @map.openDialog marker
          BubbleEvents.bind("dialog_content_changed", ->
            marker.bubble_view.switchTab("city_structs")
          )
          
        return 
    , 1500)
    

# Backbone.sync = (method, model) ->
#   console.log "backbone sync:", method, model




$("#latLng").bind("submit", ->
  coords = $(this).find("input").val()
  coords = Utils.parseCoords(coords)
  game.map.center coords[0], coords[1]
  return false
)

$("#findCity").bind("submit", ->
  city = $(this).find("input").val()
  Utils.geocode(city, (lat, lng) ->
    game.map.center lat, lng
  )
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