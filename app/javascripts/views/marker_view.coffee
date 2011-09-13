class MarkerView 

  constructor: (@map, @location) ->
    @marker = null
    @dialog = null
    
  draw: ->
    loc = @location.attributes
    console.log "ERROR: marker without lat,lng" unless loc.latitude
    
    latLng = new google.maps.LatLng loc.latitude, loc.longitude

    # TODO: reuse the same markers
    marker = new Marker()
    
    marker.location_id = loc.id
    if @location.type == "city"
      marker.type = "city"
      # marker.name = loc.city.name
      # marker.city = loc.city      
    else
      marker.type = "army"
      # marker.name = "Army"
      # marker.army = loc.army
    
    marker.attributes = @data
    marker.view = this
    
    marker.model = @location
    
    if @location.type == "army"
      @dialog = marker.dialog = new ArmyDialog { model: @location }
    else  
      @dialog = marker.dialog = new CityDialog { model: @location }
  
  
    @marker = marker
  
  
    # -----
    # TODO: separate these two pieces plz, the first is logic, the second view
    
    zIndex = if @location.type == "army" then -1 else -2
    @markerIcon = new google.maps.Marker({
      position: latLng,
      map: @map.map,
      player: loc.player,
      zIndex: zIndex
    })
  
    
    if @location.type == "city"  
      icon = new CityMarkerIcon(loc.city.pts, "enemy")
      @markerIcon .icon = icon.draw()
    else
      anchor = new google.maps.Point(25, 20)
      army_image = "http://" + window.http_host + "/images/map_icons/army_ally.png"
      army_icon = new google.maps.MarkerImage(army_image, null, null, anchor, null)
      @markerIcon.icon = army_icon
    
  
    
    
    @marker.unique_id = @markerIcon.__gm_id # TODO: generate a real id, using google map non public api is unsafe, check!
  
    this
      
    