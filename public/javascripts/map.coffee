class Map
  
  constructor: ->    
    @dialogs = []
    
  set_default_coords: ->
    @center_lat = @default_center_lat = 47.2
    @center_lng = @default_center_lng = 14.4
  
  get_center_and_zoom: ->
    console.log(localStorage.center_lat, localStorage.center_lng, localStorage.zoom)
    
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
      @zoom = 4
      localStorage.zoom = @zoom
    
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

  loadMarkers: (callback) ->
    center = @map.getCenter()    
    # console.log(center)
    $.getJSON("/cities/#{center.Oa}/#{center.Pa}", (datas) =>
      markers = []
      
      # console.log datas.markers.length
      for marker in datas.markers
        #console.log(marker)
        markers.push marker
      @markers = markers  
      
      @timer = new Date()    
      this.callback()
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
    
  drawMarker: (data) ->
    latLng = new google.maps.LatLng data.lat, data.lng
    
    image = "http://"+http_host+"/images/cross_red.png"
    marker = new google.maps.Marker({
      position: latLng,
      map: @map,
      icon: image
    })
    marker.name = data.city.name
    # TODO: pass more datas
    
    that = this
    google.maps.event.addListener(marker, 'click', ->
      for dia in that.dialogs
        dia.close()
        
      dialog = new google.maps.InfoWindow({
        # TODO: use handlebars
        content: "<div class='dialog'>
                    <p class='name'><a href='http://www.facebook.com/pages/a/#{this.fb_id}'>#{this.name}</a></p>
                    <p>player: X</p>
                    <p>population: y</p>
                  </div>"
      })
      dialog.open(@map, this)
      
      that.dialogs.push dialog
    )
    #console.log(latLng)

  callback: ->
    for marker in @markers
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
  
  listen: ->
    this.listen_to_bounds()
    
    google.maps.event.addListener(@map, 'zoom_changed', =>
      zoom = @map.getZoom()
      
      # if (zoom > x) 
      #   map.setZoom(10)
      #   zoom = 10
        
      localStorage.zoom = zoom   
      $(window).trigger "boundszoom_changed"
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
    
    @timer = new Date()
    $(window).bind("boundszoom_changed", ->
      time = new Date() - self.timer   
      if time > 2000     
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
      
$( ->
  map = new Map
  map.draw()
  
  #map.dialogs()
  map.loadMarkers()
  
  map.listen()
  
  #map.clickInfo()
  map.drawLines()
  
  map.startFetchingMarkers()
  
  #map.overlay()
  
  #console.log(navigator.userAgent)
  #if navigator.userAgent.match("iPad")
  map.resize()
  $(window).resize( ->
    map.resize()
  )
)
  
  


# convert some_image.bmp -resize 256x256 -transparent white favicon-256.png
# 
# convert favicon-256.png -resize 16x16 favicon-16.png
# convert favicon-256.png -resize 32x32 favicon-32.png
# convert favicon-256.png -resize 64x64 favicon-64.png
# convert favicon-256.png -resize 128x128 favicon-128.png
# 
# convert favicon-16.png favicon-32.png favicon-64.png favicon-128.png favicon-256.png -colors 256 favicon.ico