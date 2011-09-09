class MarkerView 

  constructor: (@map, @data) ->
    @marker = null
    @dialog = null
    
  draw: ->
    console.log "ERROR: marker without lat,lng" unless @data.latitude
    
    latLng = new google.maps.LatLng @data.latitude, @data.longitude
    
    
    unless @data.city == undefined
      @data.type = "city"
    else  
      @data.type = "army"
    
    
    
    army_image = "http://" + window.http_host + "/images/map_icons/army_ally.png"
    
    # TODO: reuse the same markers

    

    marker = new Marker()
    
    # TODO: cmon, this is not a view!!!!! move out... now!
    
    marker.location_id = @data.id
    if @data.type == "city"
      marker.type = "city"
      marker.name = @data.city.name
      marker.city = @data.city
      marker.army = undefined
      
    else
      marker.type = "army"
      marker.name = "Army"
      marker.army = @data.army
      marker.city = undefined;
    
    marker.attributes = @data
    marker.view = this
    
    
    
    
    # TODO: pass more datas
    
    # console.log "data: ", @data.type
    if @data.type == "army"
      marker.model = new Army @data
      @dialog = marker.dialog = new ArmyDialog { model: marker.model }
    else  
      marker.model = new City @data
      @dialog = marker.dialog = new CityDialog { model: marker.model }
  
  
    @marker = marker
  
  
    # -----
    # TODO: separate these two pieces plz, the first is logic, the second view
    
    zIndex = if @data.type == "army" then -1 else -2
    @markerIcon = new google.maps.Marker({
      position: latLng,
      map: @map.map,
      player: @data.player,
      zIndex: zIndex
    })
  
    
    if @data.type == "city"  
      icon = new CityMarkerIcon(@data.city.pts, "enemy")
      @markerIcon .icon = icon.draw()
    else
      anchor = new google.maps.Point(25, 20)
      army_icon = new google.maps.MarkerImage(army_image, null, null, anchor, null)
      @markerIcon.icon = army_icon
    
  
    
    
    @marker.unique_id = @markerIcon.__gm_id # TODO: generate a real id, using google map non public api is unsafe, check!
  
    this
      
    