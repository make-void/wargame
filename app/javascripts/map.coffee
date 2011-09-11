class Map extends Backbone.View
  
  constructor: ->
    @markerZoomMin = 8
    @max_simultaneous_markers = 600
    # @max_simultaneous_markers = 200 # if iPad || iPhone v => 4 || Android v >= 3
    # @max_simultaneous_markers = 100 # if iPhone v <= 3 || Android v <= 2
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
    
    # TODO: use class Markers extends Backbone.Collection
    
    $.getJSON("/locations/#{center.lat()}/#{center.lng()}", (data) =>
      locations = []
      for location in data.locations
        locations.push location

      this.drawMarkers locations
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
            @current_dialog = this.openBubbleView(marker) # TODO: fix the bug: try to not reopen the bubble but only render the dialog content
            google.maps.event.clearListeners(marker.view.markerIcon, "click")
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


  initMarker: (data) -> ###############
    markerView = new MarkerView(this, data)
    markerIcon = markerView.draw().markerIcon # you can access the view with marker.view
    markerIcon.setMap @map
    this.initDialog(markerView.marker)
    markerView.marker

  initDialog: (marker) ->
    google.maps.event.addListener(marker.view.markerIcon, 'click', =>
      is_same_dialog = (dialog) -> dialog.marker.unique_id != marker.unique_id
      # console.log(marker, @current_dialog.marker)
      # console.log("uid: ", @current_dialog.marker.unique_id, " - ",  marker.unique_id)
      if !@current_dialog || is_same_dialog(@current_dialog)
        @current_dialog = this.openBubbleView(marker)
        this.saveDialogState(marker)
    )
      
  openBubbleView: (marker) ->        
    @current_dialog.close() if @current_dialog

    bubbleView = new BubbleView(@map, marker)      
    bubbleView.doRender() # calls .open() internally    
    
    
    # ...
    # showSwitchButton()
    for mark in @markers    
      same_location = (m1, m2) -> 
        m1.location_id == m2.location_id
      if !_.isEqual(marker, mark) && same_location(mark, marker)
        mark.markers = @markers
        bubbleView.showSwitchButton(mark, this.openBubbleView) # executes openDialog internally
    
    # ...
    
    marker.dialog.afterRender() 
    marker.dialog.initTab "city_overview"
    
    
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




  same_city: (mark, data) ->  
    is_a_city = data.city && mark.city
    is_a_city && mark.city.id == data.city.id

  same_army: (mark, data) ->  
    is_an_army = data.army && mark.army
    is_an_army && mark.army.id == data.army.id    

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
    
