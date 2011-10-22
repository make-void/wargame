class MapMove extends MapAction # (View)
  constructor: (location) ->
    # TODO: change cursor
    @line = null
    @active = true
    @from = location.attributes
    @destination = null
    @endMarker = null
    super
    google.maps.event.addListener(@map, "mousemove", (evt) => 
      this.draw(evt)
    )
    this.deactivationHook()

  draw: (evt) ->
    
    if @active
      @destination = evt.latLng
      
      points = [
        new google.maps.LatLng(@from.latitude, @from.longitude),
        @destination
      ]
      
      @line.setMap(null) if @line
      @line = new google.maps.Polyline({
        path: points,
        strokeColor: "#FF0000",
        strokeOpacity: 1.0,
        strokeWeight: 2
      })
      @line.setMap @map
  
    
  deactivationHook: ->
    $("#map_canvas").bind("click", =>
      this.deactivate()
    )

  deactivate: ->
    # @line.setMap null
    @active = false
    @endMarker = new google.maps.Marker({
      position: @destination,
      map: @map, 
      # icon: "http://#{window.http_host}/images/map_icons/crosshair.png"
      icon: "http://#{window.http_host}/images/map_icons/point_red.png"
    })
    console.log "deact map: ", @map.controller
    console.log "deeestinatiooon: ", @destination
    @map.controller.armyMoved @from, @destination