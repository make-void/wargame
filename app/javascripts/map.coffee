class Map
  
  constructor: ->
    @markerZoomMin = 8
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
    this.dialogs = []
    
    # if this.dialogs.length != 0
    #   console.log(_.last(this.dialogs).marker.location_id)
    lastMark = _.last(this.dialogs).marker if this.dialogs.length != 0  
    
    mark = if this.dialogs.length == 0 || lastMark.location_id != marker.location_id
      marker
    else  
      nextMarker = marker
      is_army = (m) -> !m.model.attributes.city
      marker_id = (m) -> if is_army(m) then "#{m.type}_#{m.model.attributes.army.id}" else "#{m.type}_#{m.model.attributes.city.id}"
      
      for mark in @markers
        if lastMark.location_id == mark.location_id && marker_id(mark) != marker_id(lastMark) 
          # console.log(mark, marker)
          nextMarker = mark
          
      nextMarker
    
    return this.openDialog(mark)
      
  openDialog: (marker) ->    
    # $("#bubbleEvents").bind("dialog_content_changed", ->
    # setTimeout( => # FIXME: a set timeout is not the best detector of this but still... check if it works on mobile

    dialog = new DialogView(@map, marker)    
    # console.log "rendering: ", dialog
    dialog.render()
    
    this.dialogs.push dialog
      # dialog.open @map, marker
    
    dialog
      # dialog.open() # needed?
    # )
    # , 40)

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
    marker = markerView.draw().marker # you can access the view with marker.view
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
    
