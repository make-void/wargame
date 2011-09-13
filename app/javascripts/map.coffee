class Map extends Backbone.View
  
  constructor: ->
    @markerZoomMin = 8
    @max_simultaneous_markers = 600
    # @max_simultaneous_markers = 200 # if iPad || iPhone v => 4 || Android v >= 3
    # @max_simultaneous_markers = 100 # if iPhone v <= 3 || Android v <= 2
    @current_dialog = null
    @last_location_id = null
    @locations = []
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
      locations = data.locations
      this.createLocations locations
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
          if marker.model.attributes.id == @last_location_id
            @current_dialog = this.openBubbleView(marker) # TODO: fix the bug: try to not reopen the bubble but only render the dialog content
            google.maps.event.clearListeners(marker.view.markerIcon, "click")
            MapEvents.unbind("markers_loaded")
      )
      
    # others
    
  saveDialogState: (location) ->  
    localStorage.last_location_id = location.attributes.id
  
  
  # "private"
  
  initLocation: (location) -> 
    is_army = location.city == undefined
    if is_army
      new Army(location)
    else
      new City(location)
  
  # FIXME: orly? backbone_model.equal backbone_model2  - is better

  createLocations: (locations) ->
    for location in locations
      existing = false
      for loc in @locations
        # console.log "same: ", this.same_city(loc, location), "loc: ", loc, "location: ", location
        if loc.attributes.id == location.id && loc.type == location.type
          existing = true

      unless existing  
        location = this.initLocation location 
        @locations.push location
        @markers.push this.initMarker location


  initMarker: (location) -> ###############
    markerView = new MarkerView(this, location)
    markerIcon = markerView.draw().markerIcon # you can access the view with marker.view
    markerIcon.setMap @map
    this.initDialog(markerView.marker, location)
    markerView.marker

  initDialog: (marker, location) ->
    self = this
    google.maps.event.addListener(marker.view.markerIcon, 'click', ->
      self.doInitDialog(marker)
    )
    
  doInitDialog: (marker) ->
    marker_attrs = marker.model.attributes
    
    # console.log "initDialog: ", @current_dialog, marker
    is_different_from = (dialog) -> 
      dialog_attrs = dialog.marker.model.attributes
      dialog_attrs.id != marker_attrs.id || dialog_attrs.id == marker_attrs.id && dialog_attrs.type != marker.type
    if !@current_dialog || is_different_from(@current_dialog)
      @current_dialog = this.openBubbleView(marker)
      this.saveDialogState(location)
      
  openBubbleView: (marker) ->      
    map = @map
    current_dialog = @current_dialog  
    markers = @markers
    current_dialog.close() if current_dialog
    # FIXME: fix the bug that doesnt close the dialog
    # console.log "mark: ", marker
    # console.log "diag: ", current_dialog
    # console.log "map: ", map
    

    bubbleView = new BubbleView(map, marker)      
    bubbleView.doRender() # calls .open() internally    
    
    
    # ...
    # showSwitchButton()
    for mark in markers
      same_location = (m1, m2) -> 
        m1.location_id == m2.location_id
      if !_.isEqual(marker, mark) && same_location(mark, marker)
        mark.markers = markers
        bubbleView.showSwitchButton(mark, this.openBubbleView, this) # executes openDialog internally
    
    # ...
    
    marker.dialog.afterRender() 
    
    if marker.type == "city"
      marker.dialog.initTab "city_infos"
    
    
    bubbleView


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
    
