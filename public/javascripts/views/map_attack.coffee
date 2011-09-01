class MapAttack extends MapAction  # (View)
  constructor: (@location) ->    
    super
    @circle = null
    this.drawCircle()
    
    this.hoverCities()
      
  drawCircle: ->
    center = new google.maps.LatLng(@location.attributes.latitude, @location.attributes.longitude)
    @circle = new google.maps.Circle({
      map: @map,
      center: center,
      radius: 5500,
      fillColor: "#FF0000",
      fillOpacity: 0.3# ,
      strokeColor: "#CC0000",
      strokeOpacity: 0.7,
      strokeWeight: 3
    })
    @circle.setMap @map
    console.log @map
    
    
  hoverCities: ->
    for marker in @map.controller.markers # TODO: controller.markers_city
      this.hoverCity(marker) if marker.type == "city"
    
  hoverCity: (marker) ->
    addListener = google.maps.event.addListener
    
    addListener(marker, "mouseover", (evt) => 
      # FIXME: oo design: move the drawing into marker

      icon = new CityMarkerIcon(@data.city.pts, "selected")
      #icon = "http://#{window.http_host}/images/map_icons/army_enemy.png"
      if marker.icon != icon
        marker.nonhover_icon = Utils.clone_object(marker.icon)
        marker.icon = icon
        marker.setMap @map

      # addListener(marker, "mousenter", (evt) =>
      #   this.hoverCity(marker)
      # )
    )

    addListener(marker, "mouseout", (evt) =>  
      if marker.nonhover_icon
        marker.icon = marker.nonhover_icon
        marker.setMap @map
    )