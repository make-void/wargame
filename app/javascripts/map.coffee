class Map extends Backbone.View
  
  constructor: ->
    @markerZoomMin = 8
    @max_simultaneous_markers = 600
    # @max_simultaneous_markers = 200 # if iPad || iPhone v => 4 || Android v >= 3
    # @max_simultaneous_markers = 100 # if iPhone v <= 3 || Android v <= 2
    @dialogs = []
    @current_dialog = null
    @last_location_id = null
    @markers = []
    @map = null
    
  # public
  
  draw: ->
    mapView = new MapView()
    mapView.controller = this
    mapView.draw()
    @map = mapView.map
    
  loadMarkers: ->
    return if localStorage.zoom < @markerZoomMin
    this.markersCleanMax()

    center = @map.getCenter()    
    $.getJSON("/locations/#{center.lat()}/#{center.lng()}", (data) =>
      markers = []
      for marker in data.locations
        markers.push marker

      this.drawMarkers markers
      MapEvents.trigger("markers_loaded")
      #google.maps.event.addListenerOnce(@map, 'tilesloaded', callback);
    )    
    
  markersUpdateStart: -> 
    markersUpdater = new MarkersUpdater(this) # calls drawMarkers
    markersUpdater.start()
    
  center: (lat, lng) ->
    latLng = new google.maps.LatLng(lat, lng)
    @map.panTo latLng
    # panBy xy
    # panToBounds latLngBounds
    # infos: http://code.google.com/apis/maps/documentation/javascript/reference.html#LatLngBounds

  restoreState: ->
    @last_location_id = parseInt localStorage.last_location_id
    if @last_location_id
      MapEvents.bind("markers_loaded", =>
        for marker in @markers
          if marker.attributes.id == @last_location_id
            @current_dialog = this.openDialogView(marker)
            console.log(@current_dialog) # REMOVE ME
            google.maps.event.clearListeners(marker, "click")
            MapEvents.unbind("markers_loaded")
      )
      
    # others
    
  saveDialogState: (marker) ->
    localStorage.last_location_id = marker.attributes.id
  
  # "private"
  
  drawMarkers: (markers) ->
    @timer = new Date()
    for marker in markers
      this.drawMarker marker

  drawMarker: (data) ->
    draw = true
    for mark in @markers
      draw = false if this.same_city(mark, data) || this.same_army(mark, data)

    @markers.push this.initMarker(data) if draw

  same_city: (mark, data) ->  
    is_a_city = data.city && mark.city
    is_a_city && mark.city.id == data.city.id
    
  same_army: (mark, data) ->  
    is_an_army = data.army && mark.army
    is_an_army && mark.army.id == data.army.id
    

  initMarker: (data) ->
    markerView = new MarkerView(this, data)
    marker = markerView.draw().marker # you can access the view with marker.view
    marker.setMap @map
    marker.marker_view = markerView
    this.initDialog(marker)
    marker

  initDialog: (marker) ->
    google.maps.event.addListener(marker, 'click', =>
      is_same_dialog = (dialog) -> dialog.marker.unique_id != marker.unique_id
      if !@current_dialog || is_same_dialog(@current_dialog)
        @current_dialog = this.openDialogView(marker)
        this.saveDialogState(marker)
    )
      
  openDialogView: (marker) ->        
    @current_dialog.close() if @current_dialog

    dialogView = new DialogView(@map, marker)        
    marker.dialog_view = dialogView
    dialogView.doRender() # calls .open() internally    
    
    # ...
    # showSwitchButton()
    
    # console.log(@markers)
    for mark in @markers    
      same_location = (m1, m2) -> 
        m1.location_id == m2.location_id
      if !_.isEqual(marker, mark) && same_location(mark, marker)
        dialogView.showSwitchButton(mark, this.openDialog) # executes openDialog internally
    
    # ...
    
    marker.dialog.afterRender() 
    this.dialogs.push dialogView
        
    dialogView


  markersCleanMax: ->
    max_markers = @max_simultaneous_markers
    if @markers.length > max_markers
      for marker in @markers[0..-max_markers+1]
        marker.setMap null 
      @markers = @markers[-max_markers..-1]


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
    
