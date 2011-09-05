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
    

    marker.view = self
    marker.model  = null
    marker.dialog = null
    
    
    
    # TODO: pass more datas
    
  
    google.maps.event.addListener(marker, 'click', =>
      this.doAttachDialog()
    )
    #console.log(latLng)
    this
  
  doAttachDialog: ->
    if @data.type == "army"
      # TODO: da disegnare al posto giusto
      @marker.model = new Army @data
      @marker.dialog = new ArmyDialog { model: @marker.model }
    else  
      @marker.model = new City @data
      @marker.dialog = new CityDialog { model: @marker.model }
      
    @map.attachDialog(@marker)