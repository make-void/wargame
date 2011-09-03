# DON'T include this in prodction!!!

# debug

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