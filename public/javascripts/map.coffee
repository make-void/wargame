class Map
  
  constructor: ->

    @max_simultaneous_markers = 600
    # @max_simultaneous_markers = 200 # if iPad || iPhone v => 4 || Android v >= 3
    # @max_simultaneous_markers = 100 # if iPhone v <= 3 || Android v <= 2
    @dialogs = []
    @markers = []
    @map = null
    
  # public
  
  draw: ->
    mapView = new MapView()
    mapView.controller = this
    mapView.draw()
    @map = mapView.map
    
  markersUpdateStart: -> 
    markersUpdater = new MarkersUpdater(this)
    markersUpdater.start()
    
  center: (lat, lng) ->
    latLng = new google.maps.LatLng(lat, lng)
    # @map.setCenter latLng
    @map.panTo latLng
    # panBy xy
    # panToBounds latLngBounds
    # infos: http://code.google.com/apis/maps/documentation/javascript/reference.html#LatLngBounds
    
  
  # "private"
  
  markersCleanMax: ->
    max_markers = @max_simultaneous_markers
    if @markers.length > max_markers
      for marker in @markers[0..-max_markers+1]
        marker.setMap null 
      @markers = @markers[-max_markers..-1]

  loadMarkers: ->
    # markersLoader = new MarkersLoader()
    # markersLoader.get  ->
    return if localStorage.zoom < @markerZoomMin
    this.markersCleanMax()

    center = @map.getCenter()    
    $.getJSON("/locations/#{center.lat()}/#{center.lng()}", (data) =>
      markers = []
      for marker in data.locations
        markers.push marker
  
      this.drawMarkers markers
      #google.maps.event.addListenerOnce(@map, 'tilesloaded', callback);
    )  
          
  attachDialog: (marker) ->
    for dia in this.dialogs
      dia.dialog.close()
      
    # if this.dialogs.length != 0
    #   console.log(_.last(this.dialogs).marker.location_id)
      
    if this.dialogs.length == 0 ||  _.last(this.dialogs).marker.location_id != marker.location_id
      # open a dialog
      setTimeout( => # FIXME: a set timeout is not the best detector of this but still... check if it works on mobile
        dialog = new DialogView(@map, marker)    
        this.dialogs.push dialog
      , 10)
    else
      for mark in @markers
        if marker.location_id == mark.location_id && _.last(this.dialogs).marker != mark
          nextMarker = mark
      # open a hidden dialog on the same location
      setTimeout( => # FIXME: a set timeout is not the best detector of this but still... check if it works on mobile
        dialog = new DialogView(@map, nextMarker)    
        this.dialogs.push dialog
      , 10)

  drawMarkers: (markers) ->
    @timer = new Date()
    
    for marker in markers
      this.drawMarker marker

  drawMarker: (data) ->
    draw = true
    for mark in @markers
      is_a_city =  data.city && mark.city
      draw = false if is_a_city && mark.city.id == data.city.id # is the same city
        
    this.doMarkerDrawing(data) if draw
    # console.log("drawing") if draw
    
  doMarkerDrawing: (data) ->
    markerView = new MarkerView(this, data)
    marker = markerView.draw().marker
    @markers.push marker
    marker.setMap @map
  
  clearMarkers: ->
    for marker in @markers
      marker.setMap null 
    @markers = []
  
  clickInfo: ->
    google.maps.event.addListener(@map, 'click', (evt) ->
      # console.log evt.latLng.lat(), evt.latLng.lng()
    )    
    

  # exceptions

  raise: (message) ->
    console.log "Exception: ", message    

  # debug: (what) ->
  #   $(window).oneTime(1000, ->
  #     army = null
  #     for marker in map.markers
  #       # console.log marker
  #       if marker.type == "army"
  #         army = marker          
  #         break
  # 
  #     # console.log "loc:", army.dialog.el
  # 
  # 
  #     # TODO: delete me?
  #     #
  # 
  #     window.arm = army
  #     army.dialog.render()
  #     $(army.dialog.el).find(".#{what}").trigger("click")
  #   )
    
