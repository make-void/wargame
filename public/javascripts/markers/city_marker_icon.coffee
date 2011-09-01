class CityMarkerIcon
  constructor: (@pts) ->
    
  draw: ->
    scale = Utils.city_scale @pts
    width = 90*scale
    height = 59*scale
    anchor = new google.maps.Point width/2, height/2
    size = new google.maps.Size width, height
    city_image = "http://#{window.http_host}/images/map_icons/city_enemy.png"
    new google.maps.MarkerImage(city_image, null, null, anchor, size)