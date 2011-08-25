# free unused functions! trash your old coffee here!

class Map
    
  drawSimpleMarker: (lat, lng) ->
    latLng = new google.maps.LatLng lat, lng
    image = "http://"+http_host+"/images/cross_blue.png"
    marker = new google.maps.Marker({
      position: latLng,
      map: @map,
      icon: image
    })


  drawLines: ->
    lat = 0
    lats = [43..44]
    lngs = [11..12]
    range = new LLRange(43.7, 11.2, 0.1, 0.01)

    self = this
    range.each (lat, lng) ->
      #console.log lat, lng
      self.drawSimpleMarker lat, lng
