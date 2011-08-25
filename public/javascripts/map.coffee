class Map
  
  constructor: ->
    @markerZoomMin = 7    
    @max_simultaneous_markers = 600
    @dialogs = []
    @markers = []
    @defaultZoom = 5
    
  set_default_coords: ->
    @center_lat = @default_center_lat = 47.2
    @center_lng = @default_center_lng = 14.4
  
  get_center_and_zoom: ->
    #console.log(localStorage.center_lat, localStorage.center_lng, localStorage.zoom)
    
    if localStorage.center_lat && localStorage.center_lng
      @center_lat = parseFloat localStorage.center_lat
      @center_lng = parseFloat localStorage.center_lng
    else
      this.set_default_coords()
      localStorage.center_lat = @center_lat
      localStorage.center_lng = @center_lng
      
    if localStorage.zoom
      @zoom = parseInt localStorage.zoom
    else
      @zoom = @defaultZoom
      localStorage.zoom = @zoom
    
  center: (lat, lng) ->
    latLng = new google.maps.LatLng(lat, lng)
    # @map.setCenter latLng
    @map.panTo latLng
    # panBy xy
    # panToBounds latLngBounds
    # infos: http://code.google.com/apis/maps/documentation/javascript/reference.html#LatLngBounds
    
  draw: ->  
    this.get_center_and_zoom()
    mapDiv = document.getElementById 'map_canvas'
    # console.log "lat: ", @center_lat, "lng: ", @center_lng, "zoom: ", @zoom 
    @center_lat = @default_center_lat unless @center_lat
    @center_lng = @default_center_lng unless @center_lng
    # @zoom = 2
    @map = new google.maps.Map( mapDiv, {
      center: new google.maps.LatLng(@center_lat, @center_lng),
      zoom: @zoom,
      #mapTypeId: google.maps.MapTypeId.ROADMAP,
      mapTypeId: google.maps.MapTypeId.TERRAIN,
      disableDefaultUI: true
    })

  resize: -> 
    height = $("body").height() - $("h1").height() - 30
    $("#container, #map_canvas").height height

  markersCleanMax: ->
    max_markers = @max_simultaneous_markers
    if @markers.length > max_markers
      for marker in @markers[0..-max_markers+1]
        marker.setMap null 
      @markers = @markers[-max_markers..-1]

  loadMarkers: (callback) ->
    return if localStorage.zoom < @markerZoomMin
    this.markersCleanMax()
    
    
    center = @map.getCenter()    
    # console.log(center)
    $.getJSON("/locations/#{center.Oa}/#{center.Pa}", (datas) =>
      markers = []
      
      #console.log datas.markers.length
      for marker in datas.markers
        #console.log(marker)
        markers.push marker

      
      @timer = new Date()    
      this.callback(markers)
      #google.maps.event.addListenerOnce(@map, 'tilesloaded', callback);
    )

  drawSimpleMarker: (lat, lng) ->
    latLng = new google.maps.LatLng lat, lng
    image = "http://"+http_host+"/images/cross_blue.png"
    marker = new google.maps.Marker({
      position: latLng,
      map: @map,
      icon: image
    })
    


  doMarkerDrawing: (data) ->
    console.log "ERROR: marker without lat,lng" unless data.latitude
    
    latLng = new google.maps.LatLng data.latitude, data.longitude
    
    # image = "http://"+http_host+"/images/cross_red.png"
    city_image = "http://" + http_host + "/images/map_icons/city_enemy.png"
    army_image = "http://" + http_host + "/images/map_icons/army_ally.png"
    marker = new google.maps.Marker({
      position: latLng,
      map: @map,
      player: data.player
    })
    
    unless data.city.name == null
      marker.name = data.city.name
      marker.city = data.city
      marker.army = undefined
      marker.icon = city_image
    else
      marker.name = "Army"
      marker.army = data.army
      marker.city = undefined;
      marker.icon = army_image

    @markers.push marker
    # TODO: pass more datas
    
    that = this
    google.maps.event.addListener(marker, 'click', ->
      for dia in that.dialogs
        dia.close()
        
      # TODO: use handlebars
      content_string = "
      <div class='dialog'>
        <p class='name'>#{this.name}</p>
        <p>player: #{this.player.name}</p>
               "
      content_string += "<p>population: y</p>" if this.city
      content_string += "</div>"

        
      dialog = new google.maps.InfoWindow({
        content: content_string
      })
      dialog.open(@map, this)
      
      that.dialogs.push dialog
    )
    #console.log(latLng)
    
    
  drawMarker: (data) ->
    draw = true
    for mark in @markers
      is_a_city =  data.city && mark.city
      draw = false if is_a_city && mark.city.city_id == data.city.city_id # is the same city
        
    this.doMarkerDrawing(data) if draw
    # console.log("drawing") if draw
      

  callback: (markers) ->
    for marker in markers
      this.drawMarker marker
  
  listen_to_bounds: ->
    google.maps.event.addListenerOnce(@map, "bounds_changed", =>
      center = @map.getCenter()
      # console.log(center)
      localStorage.center_lat = center.Oa
      localStorage.center_lng = center.Pa     
      this.listen_to_bounds()  
      $(window).trigger "boundszoom_changed"
    )
  
  clearMarkers: ->
    for marker in @markers
      marker.setMap null 
    @markers = []
  
  listen: ->
    this.listen_to_bounds()
    
    google.maps.event.addListener(@map, 'zoom_changed', =>
      zoom = @map.getZoom()
      
      if (zoom < @defaultZoom) 
        @map.setZoom(@defaultZoom)
        zoom = @defaultZoom
        
      if (zoom > 11) 
        @map.setZoom(11)
        zoom = 11
 
      localStorage.zoom = zoom   
      # $(window).trigger "boundszoom_changed"
      
      if zoom < @markerZoomMin
        this.clearMarkers()
        
    )
  
  overlay: ->  
    boundaries = new google.maps.LatLngBounds(new google.maps.LatLng(43.273978,10.25124454498291), new google.maps.LatLng(44.273978,12.25124454498291));
    overlay = new google.maps.GroundOverlay("/images/overlay.png", boundaries)
    overlay.setMap @map
    
  clickInfo: ->
    google.maps.event.addListener(@map, 'click', (evt) ->
      console.log evt.latLng.Oa, evt.latLng.Pa
    )

  drawLine: (points) ->
    line = new google.maps.Polyline({
      path: points,
      strokeColor: "#FF0000",
      strokeOpacity: 1.0,
      strokeWeight: 2
    });
    line.setMap(@map)

  drawLines: ->
    lat = 0
    lats = [43..44]
    lngs = [11..12]
    range = new LLRange(43.7, 11.2, 0.1, 0.01)

    self = this
    range.each (lat, lng) ->
      #console.log lat, lng
      self.drawSimpleMarker lat, lng
      
  startFetchingMarkers: -> # when latchanges
    self = this
    
    time2 = new Date()
    @timer = new Date()
    
    $(window).bind("boundszoom_changed", ->
      time = new Date() - self.timer   
      time2 = new Date()
      if time > 1000
        self.loadMarkers()
        time2 = new Date()
        self.timer = new Date()
    )
    
    $(window).everyTime(1500, (i) ->
      time3 = new Date() - time2
      if time3 > 1000 && time3 < 2000
        self.loadMarkers() 
    )
    
    

class LLRange
  constructor: (lat, lng, range, prec) ->
    times = range / prec 
    @lats =  []
    @lngs = []
    for t in [0..times]
      @lats.push lat+prec*t 
    for t in [0..times]
      @lngs.push lng+prec*t 
    
  each: (fn) ->
    for lat in @lats
      for lng in @lngs
        fn(lat, lng)
      

  


# convert some_image.bmp -resize 256x256 -transparent white favicon-256.png
# 
# convert favicon-256.png -resize 16x16 favicon-16.png
# convert favicon-256.png -resize 32x32 favicon-32.png
# convert favicon-256.png -resize 64x64 favicon-64.png
# convert favicon-256.png -resize 128x128 favicon-128.png
# 
# convert favicon-16.png favicon-32.png favicon-64.png favicon-128.png favicon-256.png -colors 256 favicon.ico