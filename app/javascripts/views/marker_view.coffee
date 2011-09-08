class MarkerView 

  constructor: (@map, @data) ->
    @marker = null
    
  draw: ->
    console.log "ERROR: marker without lat,lng" unless @data.latitude
    
    latLng = new google.maps.LatLng @data.latitude, @data.longitude
    
    
    unless @data.city == undefined
      @data.type = "city"
    else  
      @data.type = "army"
    
    
    
    army_image = "http://" + window.http_host + "/images/map_icons/army_ally.png"
    
    # TODO: reuse the same markers
    
    zIndex = if @data.type == "army" then -1 else -2
    
    @marker = marker = new google.maps.Marker({
      position: latLng,
      map: @map.map,
      player: @data.player,
      zIndex: zIndex
    })
    
    # TODO: cmon, this is not a view!!!!! move out... now!
    
    marker.location_id = @data.id
    if @data.type == "city"
      marker.type = "city"
      marker.name = @data.city.name
      marker.city = @data.city
      marker.army = undefined
      icon = new CityMarkerIcon(@data.city.pts, "enemy")
      marker.icon = icon.draw()
      
    else
      marker.type = "army"
      marker.name = "Army"
      marker.army = @data.army
      marker.city = undefined;
      anchor = new google.maps.Point(25, 20)
      army_icon = new google.maps.MarkerImage(army_image, null, null, anchor, null)
      marker.icon = army_icon
    
    marker.attributes = @data
    marker.view = this
    
    @marker.unique_id = marker.__gm_id # TODO: generate a real id, using google map non public api is unsafe, check!
    
    
    # TODO: pass more datas
    
    console.log "data: ", @data.type
    if @data.type == "army"
      @marker.model = new Army @data
      @dialog = @marker.dialog = new ArmyDialog { model: @marker.model }
    else  
      @marker.model = new City @data
      @dialog = @marker.dialog = new CityDialog { model: @marker.model }
    
    #console.log(latLng)
    this
      
    